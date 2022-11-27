import std/[macros, random, hashes, tables, sets, sequtils, algorithm, strformat]

var 
  entropy {.compileTime.} = initRand(hash(CompileTime & CompileDate) and 0x7FFFFFFF)
  flattenId {.compileTime.}: int = 0

var uniqueSeen {.compileTime.} = 0
template genUniqueInt(max: int = int.high-1): int = 
  var result = uniqueSeen
  uniqueSeen.inc

  result


proc process(stateIdent: NimNode, switchArms: var seq[NimNode], ar: openArray[NimNode], index: int, exitId: int): int {.discardable, compileTime.} = 
  echo &"called with arms: {repr(switchArms)}, index: {index}, exitId: {exitId}"
  if index+1 != ar.len:
    echo "callig nextId"
  let 
    n = ar[index]
    nextId = if index+1 == ar.len: exitId else: process(stateIdent, switchArms, ar, index + 1, exitId)

  discard entropy.next

  result = genUniqueInt()


  case n.kind
  of nnkIfStmt:
    var resIf = nnkIfStmt.newTree()
    for arm in n:
      if arm.kind == nnkElifBranch:
        let 
          comp = arm[0]
        
        # recursively add inner if 
        let armId = process(stateIdent, switchArms, toSeq(arm[1]), 0, nextId)
        resIf.add nnkElifBranch.newTree(
          comp,
          nnkStmtList.newTree(
            quote do:
              `stateIdent` = `armId`
          )
        )
      elif arm.kind == nnkElse:
        # recursively add inner if 
        let armId = process(stateIdent, switchArms, toSeq(arm[0]), 0, nextId)
        resIf.add  nnkElse.newTree(
          nnkStmtList.newTree(
            quote do:
              `stateIdent` = `armId`
          )
        )
    
    # add resulting if statement
    switchArms.add nnkOfBranch.newTree(
      newLit result,
      nnkStmtList.newTree(
        resIf,
        quote do:
          `stateIdent` = `nextId`
      )
    )
  else:
    echo "adding nonif branch with ", result
    switchArms.add nnkOfBranch.newTree(
      newLit result,
      nnkStmtList.newTree(
        n,
        quote do:
          `stateIdent` = `nextId`
      )
    )

  echo "arms: ", $(switchArms.repr)
  echo "\n\n"
  

macro flatten*(stmts: untyped) = 
  stmts.expectKind nnkStmtList
  stmts.expectMinLen 1

  result = newStmtList()

  let 
    stateIdent = ident("flatten_state_" & $flattenId)
    exitState: int = genUniqueInt()
  var 
    switchArms: seq[NimNode] = @[nnkElse.newTree(
      nnkStmtList.newTree(
        nnkDiscardStmt.newTree(
          newEmptyNode()
        )
      )
    )] # add empty else stmt so compiler won't scream

  flattenId.inc

  # result.add quote do:
  #   var `stateIdent`: int = `entryState`

  # build bb table

  let 
    entryState = process(stateIdent, switchArms=switchArms, index=0, ar=stmts.toSeq, exitId=exitState) # nnkCaseStmts -> first nnkOfBranch -> [0] = literal

  # entropy.shuffle switchArms

  result.add quote do:
    var `stateIdent`: int = `entryState`

  switchArms.reverse

  var fullCaseStatement = nnkCaseStmt.newTree(stateIdent)
  for s in switchArms: fullCaseStatement.add s

  result.add quote do:
    while `stateIdent` != `exitState`:
      `fullCaseStatement`

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
  expandMacros:
    var 
      x = 4
      y = 10
      z = 9
    flatten():
      x = 4

      if x == 4:
        x = 10
        y = 18
      else:
        x = 30

      z = x + y

      if z > y + 10:
        y = 18
      z = 43

      

      