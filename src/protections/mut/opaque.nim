import std/[macros, random, hashes]

var entropy {.compileTime.} = initRand(hash(CompileTime & CompileDate) and 0x7FFFFFFF)

type
  GenResultInt = object
    n: NimNode
    res: int

proc genIntExpr(passes: uint = 45): GenResultInt {.compileTime.} =
  echo "sdsdfsdf"

  let initial = rand(0xffff) + 1

  var 
    res = newLit initial
    resValue = initial

  proc choose[T](x: openArray[T]): T =
    x[entropy.rand(x.high)]

  proc binMut(resExpr: var NimNode) = 
    const 
      binOps = ["+", "-", "*", "div", "mod", "xor", "and", "shl", "shr", "or"]
      unOps = ["not", "-"]

    let op = binOps.choose
    var rhs: int = 0

    if op == "div":
      rhs = 1 + entropy.rand(0xffff)
    elif op in ["*", "shl", "shr"]:
      rhs = entropy.rand(sizeof(int)) + 1
    else:
      rhs = entropy.rand(0xffffff)

    case op
    of "+": resValue += rhs
    of "-": resValue -= rhs
    of "*": resValue *= rhs
    of "div": resValue = resValue div rhs
    of "mod": resValue = resValue mod rhs
    of "xor": resValue = resValue xor rhs
    of "and": resValue = resValue and rhs
    of "shl": resValue = resValue shl rhs
    of "shr": resValue = resValue shr rhs
    of "or": resValue = resValue or rhs

    let old = resExpr.copy
    resExpr = nnkInfix.newTree(
      newIdentNode(op),
      old,
      newLit(rhs)
    )

  for _ in 0..passes: binMut(res)
  
  return GenResultInt(n: res.copy, res: resValue)

var identCounter {.compileTime.} = 0

macro alwaysTrue*(trueBranch, falseBranch: untyped, passes: static[uint] = 50): NimNode =
  result = newStmtList()

  let 
    expression: GenResultInt = genIntExpr(passes)
    predicted = newLit expression.res
    arithmethic = expression.n


  result.add nnkIfStmt.newTree(
    nnkElifBranch.newTree(
      nnkInfix.newTree(
        newIdentNode("=="),
        arithmethic,
        predicted
      ),
      trueBranch
    ),
    nnkElse.newTree(
      falseBranch
    )
  )

when isMainModule:
  expandMacros:
    alwaysTrue():
      echo "awlasd"
    do:
      echo "never"

