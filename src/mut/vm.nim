import std/[macros, tables]
import shared


# Intermidiate Representation
type
  IRKind* {.pure.} = enum
    LoadVar
    StoreVar

    Add
    Sub
    Mul
    Div

    Or
    And
    Xor
    Not

    CallExternal

    Push
    Pop

    Jump

  IROperand* {.pure.} = enum
    Immediate
    Var
    None

  IRJumpKind* {.pure.} = enum
    Less
    Greater
    Equals
    NotEquals

  IRFuncArgKind {.pure.} = enum
    ReturnValPtr
    ExternalProcPtr
    Real

  IRReg {.pure.} = enum
    A
    B
    C


  IRInstruction = object
    case kind: IRKind
    of Jump:
      jumpKind: IRJumpKind
    of LoadVar:
      target: IRReg
    else: discard
    op: IROperand

  
  IRBasicBlock = object
    virtualAddr: uint
    instr: seq[IRInstruction]


# Actual VM
type
  VMWord = int64

  VMFunction = object
    rawBody: NimNode
    args: seq[IRFuncArgKind]

    bbs: seq[IRBasicBlock]
    identToSlot: Table[NimNode, uint]

proc compileInfix(inf: NimNode, retValIn: IrReg = IrReg.A): seq[IRInstruction] {.compileTime.} =
  let
    op = inf[0]
    lhs = inf[1]
    rhs = inf[2]


macro virtualize*(fun: typed): NimNode = 
  result.expectKind nnkProcDef

  let 
    params = fun[3] # nnkProcDef -> nnkFormalParams
    retType = params[0]

    funcBody = fun[6]

when isMainModule:
  dumpAstGen():
    type
      TestObj = object
        x: int

    proc toVirt(x, y, z: int, test: TestObj): int = 
      result = x + y - y * 2 div 4 * 8

      if x > y:
        result = z

      test.x = y



