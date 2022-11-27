import std/[macros, random, hashes, sequtils, algorithm]

var 
  entropy {.compileTime.} = initRand(hash(CompileTime & CompileDate) and 0x7FFFFFFF)
  flattenId {.compileTime.}: int = 0

var uniqueSeen {.compileTime.} = 0
template genUniqueInt(max: int = int.high-1): int = 
  var result = uniqueSeen
  uniqueSeen.inc

  result

type
  Arm = object
    id: int
    node: NimNode

  JumpTable = object
    name: NimNode
    arms: seq[Arm]
    entryId, exitId: int

    rawStmts: NimNode

    postIfStmt: NimNode


proc processBlock(switchArms: var JumpTable, ar: openArray[NimNode], index: int, exitId: int): int {.discardable, compileTime.} = 
  let 
    n = ar[index]
    nextId = if index+1 == ar.len: exitId else: processBlock(switchArms, ar, index + 1, exitId)
    stateIdent = switchArms.name

  discard entropy.next

  result = genUniqueInt()

  var resultNode: NimNode

  case n.kind
  of nnkIfStmt:
    var resIf = nnkIfStmt.newTree()
    for arm in n:
      if arm.kind == nnkElifBranch:
        let 
          comp = arm[0]
        
        # recursively add inner if 
        let armId = processBlock(switchArms, toSeq(arm[1]), 0, nextId)
        resIf.add nnkElifBranch.newTree(
          comp,
          nnkStmtList.newTree(
            (quote do:
              `stateIdent` = `armId`),
            switchArms.postIfStmt
          )
        )
      elif arm.kind == nnkElse:
        # recursively add inner if 
        let armId = processBlock(switchArms, toSeq(arm[0]), 0, nextId)
        resIf.add  nnkElse.newTree(
          nnkStmtList.newTree(
            (quote do:
              `stateIdent` = `armId`),
            switchArms.postIfStmt
          )
        )
    
    # add resulting if statement
    resultNode = nnkStmtList.newTree(
        resIf,
        quote do:
          `stateIdent` = `nextId`
      )

  else:
    resultNode = nnkStmtList.newTree(
        n,
        quote do:
          `stateIdent` = `nextId`
      )
  
  switchArms.arms.add Arm(
      id: result, 
      node: resultNode
  )


proc getTable(jt: var JumpTable) {.compileTime.} = 
  jt.exitId = genUniqueInt()
  jt.name = newIdentNode("flatten_state_" & $flattenId)

  flattenId.inc
  let stmtArr = jt.rawStmts.toSeq

  jt.entryId = processBlock(jt, index=stmtArr.low, ar=stmtArr, exitId=jt.exitId)

  
proc buildSwitch(j: var JumpTable): NimNode {.compileTime.} = 
  j.postIfStmt = quote do:
    continue

  j.getTable()

  result = newStmtList()
  let
    litName = j.name
    litEntry = newLit j.entryId
    litExit = newLit j.exitId

  result.add quote do:
    var `litName`: int = `litEntry`

  var caseStmt = nnkCaseStmt.newTree(litName)

  for arm in j.arms.reversed:
    let id = newLit arm.id
    caseStmt.add nnkOfBranch.newTree(
      newLit arm.id,
      newStmtList(
      (quote do:
        echo "executing: ", $`id`),
      arm.node
      )
    )

  caseStmt.add(
    nnkElse.newTree(
      nnkStmtList.newTree(
        nnkDiscardStmt.newTree(
          newEmptyNode()
        )
      )
    )
  )

  result.add quote do:
    while `litName` != `litExit`:
      `caseStmt`

macro flatten*(stmts: untyped) = 
  stmts.expectKind nnkStmtList
  stmts.expectMinLen 1

  var jt = JumpTable(rawStmts: stmts)

  return jt.buildSwitch

  

when isMainModule:
  # dumpAstGen:
  #   if 10 == 3:
  #     true
  #   else:
  #     false

  #   let x = 3
  #   case x
  #   of 4:
  #     1
  #   else:
  #     discard
  var 
      x = 4
      y = 10
      z = 9
  expandMacros:
    flatten():
      echo "x val: ", x

      if x < y:
        x = 40
      else:
        echo " x > y"

      echo x

      

      