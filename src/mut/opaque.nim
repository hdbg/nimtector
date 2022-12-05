import std/[macros, random, hashes, options]
import shared

type
  GeneratedTypeField = object
    name: NimNode
    kind: NimNode
  
  GeneratedType = object
    name: NimNode
    fields: seq[GeneratedTypeField]

    def: NimNode

  CollectionMutationKind {.pure.} = enum
    RandomAdded
    RandomRemoved
    RandomModifed
    PutBack
    PutFront
    OverWritten

  MutationKind {.pure.} = enum
    ObjectDeclared
    AttrModifed
    AttrOverwitten # with literal
    AttrComparedWithLiteral
    CompatibleAttrModified
    CompatibleAttrCopied
    CompatibleAttrCompared
    Collection

  AdressField = object
    kind: GeneratedType
    field: GeneratedTypeField

  Mutation = object
    name: NimNode
    objType: GeneratedType
    field: Option[GeneratedTypeField]

    case kind: MutationKind
    of AttrOverwitten:
      with: NimNode
    of AttrModifed:
      modifierStmt: NimNode
    of AttrComparedWithLiteral:
      literal: NimNode
    of CompatibleAttrCopied:
      copiedType: AdressField
      copyObjName: NimNode
    of CompatibleAttrModified:
      modifyType: AdressField
      modiferName: NimNode
      compModiferStmt: NimNode
    of CompatibleAttrCompared:
      compType: AdressField
      compName: NimNode
    of Collection:
      collKind: CollectionMutationKind
    else: discard
    

let fieldsKinds {.compileTime.} = [
  ident"string", ident"int", ident"uint", ident"float", 
  ident"seq[int]", ident"seq[uint]", ident"seq[float]", ident"seq[string]"
]

proc genTypes(count: uint = 4, maxFields: uint = 10, allow_inter_relation = false, inter_prob: float = 0.2): seq[GeneratedType] {.compileTime.} =
  assert inter_prob <= 1.0

  count.loop:
    var typeName = "GenType".unique

    var fields: seq[GeneratedTypeField]

    loop entropy.rand(maxFields):
      var 
        fieldName = "genTypeField".unique
        fieldKind = fieldsKinds.choice

      if allow_inter_relation and (inter_prob > entropy.rand(1.0)) and result.len > 0:
        fieldKind = result.choice.name

      fields.add GeneratedTypeField(name: fieldName, kind: fieldKind)

    var 
      fieldsDef = nnkRecList.newTree()

    for f in fields:
      fieldsDef.add nnkIdentDefs.newTree(
        f.name,
        f.kind,
        newEmptyNode()
      )

    var typeDef = nnkTypeDef.newTree(
        typeName,
        newEmptyNode(),
        nnkObjectTy.newTree(
          newEmptyNode(),
          newEmptyNode(),
          fieldsDef
      )
    )

    result.add GeneratedType(name: typeName.move, fields: fields.move, def: typeDef.move)

proc pack(x: seq[GeneratedType]): NimNode {.compileTime.} = 
  result = nnkTypeSection.newTree()
  for t in x:
    result.add t.def

when isMainModule:
  static:
    let 
      types = genTypes(10, allow_inter_relation=true, maxFields=4)
      sec = types.pack

    echo repr sec


#[ basic idea is to generate valid mutation pipeline 
DeclVar -> AttrModify -> AttrComp -> DeclVar -> etc..
And then to generate code
]#

type
  Types = seq[GeneratedType]
  Pipeline = seq[Mutation]

proc genPipeline(count: uint = 10, types: Types): Pipeline {.compileTime.} =
  var 
    passes: seq[tuple[cb: proc () {.closure.}, predicate: proc(): bool{.closure.}]]

  var defs: seq[Mutation]

  template addPass(body, predic: untyped) =
    let
      cb = proc() {.closure.} = 
        body
      verifier = proc(): bool {.closure.} = 
        predic

    passes.add (cb: cb, predicate: verifier)

  # decl var
  addPass():
    let
      varType = choice types
      varName = "genVarDef".unique

    let res =  Mutation(kind: MutationKind.ObjectDeclared, name: varName, objType: varType, field: none[GeneratedTypeField]())
    result.add res
    defs.add res
  do:
    true

  # modify attr
  addPass():
    let def = choice defs
  do:
    return defs.len > 0