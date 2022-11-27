import std/[random, hashes, macros, math]

var entropyGen {.compileTime.} = initRand(hash(CompileTime & CompileDate) and 0x7FFFFFFF)

proc choice[T](x: openArray[T]): T = 
  return x[entropyGen.rand(x.high)]

type
  DeclConfig* = object
    prob: float
    copyInit: float

  ProbConfig* = object
    prob: float

  BogusLoopConfig* = object
    prob: float
    bodyMutations: int
    depthLimit: int

  MutationConfig* = object
    intDecls*: DeclConfig
    intModifications*: ProbConfig

    floatDecls*: DeclConfig
    floatModifications*: ProbConfig

    bogusLoop: BogusLoopConfig

type
  MutationContext = ref object
    intDecls: seq[NimNode]
    floatDecls: seq[NimNode]
    entropy: Rand

    cyclesLeft: int

    config: MutationConfig

  Mutator = object
    name: string
    cb: proc(ctx: MutationContext, target: var NimNode, totalAdded: var int, depth: int = 0,)



var mutators {.compileTime.}: seq[Mutator]

proc mutate(ctx: MutationContext, target: var NimNode, depth: int = 0): int {.compileTime, discardable.} = 
  while ctx.cyclesLeft > 0:
    block founder:
      for m in mutators:
        m.cb(ctx, target, result, depth)

template newMutation(n: string, body: untyped) =
  static:
    let cb = proc (ctx {.inject.}: MutationContext, target {.inject.}: var NimNode, totalAdded {.inject.}: var int, depth {.inject.}: int = 0) {.compileTime.} =
      if ctx.cyclesLeft <= 0: return

      let mcfg {.inject, used.} = ctx.config
      body

      echo n, " ", ctx.cyclesLeft

      totalAdded.inc
      ctx.cyclesLeft.dec

    mutators.add Mutator(name: n, cb: cb)

template fire(t: float) = 
  mixin ctx
  if t < ctx.entropy.rand(1.0): return

let
  intMathOps {.compileTime.} = ["+", "-", "div", "*", "mod"]
  floatMathOps {.compileTime.} = ["+", "-", "/", "*", "mod"]

# declare int
newMutation("intDecl"):
  fire ctx.config.intDecls.prob

  let newSym = newIdentNode("i" & $len(ctx.intDecls))
  
  if (ctx.config.intDecls.copyInit < ctx.entropy.rand(1.0)) or ctx.intDecls.len == 0:
    let randInitializer = entropyGen.rand(int.high div (2 ^ 15))
    target.add quote do:
      var `newSym` {.used.}: int = `randInitializer`
  else:
    let another = choice ctx.intDecls
    target.add quote do:
      var `newSym` {.used.}: int = `another`

  ctx.intDecls.add(newSym)

# declare float
newMutation("floatDecl"):
  fire ctx.config.floatDecls.prob

  let newSym = newIdentNode("f" & $len(ctx.floatDecls))

  if (ctx.config.floatDecls.copyInit < ctx.entropy.rand(1.0)) or ctx.floatDecls.len == 0:
    let randInitializer = entropyGen.rand(10.5)
    target.add quote do:
      var `newSym` {.used.}: float = `randInitializer`
  else:
    let another = choice ctx.floatDecls
    target.add quote do:
      var `newSym` {.used.}: float = `another`

  ctx.floatDecls.add(newSym)

newMutation("modifyInt"):
  fire mcfg.intModifications.prob

  if ctx.intDecls.len < 1: return

  let 
    sym = choice ctx.intDecls
    rhs = newIntLitNode ctx.entropy.rand(int.high - 1)
    op = newIdentNode choice intMathOps

  target.add quote do:
    `sym` = `op`(`sym`, `rhs`)

newMutation("modifyFloat"):
  fire mcfg.floatModifications.prob

  if ctx.floatDecls.len < 1: return

  let 
    sym = choice ctx.floatDecls
    rhs = newFloatLitNode ctx.entropy.rand(99.9)
    op = newIdentNode choice floatMathOps

  target.add quote do:
    `sym` = `op`(`sym`, `rhs`)

var bogusId {.global, compileTime.} = 0

newMutation("bogusLoop"):

  fire mcfg.bogusLoop.prob
  if depth > mcfg.bogusLoop.depthLimit:
    # echo "depth lim, ", $depth 
    return

  let cyclesCount = ctx.entropy.rand(50)
  var loopBody = nnkStmtList.newTree()
  
  var newCtx = MutationContext(config: ctx.config, entropy: ctx.entropy, cyclesLeft: min(ctx.cyclesLeft, mcfg.bogusLoop.bodyMutations))

  for i in ctx.intDecls: newCtx.intDecls.add i
  for i in ctx.floatDecls: newCtx.floatDecls.add i
  
  bogusId.inc

  let myId = bogusId

  echo "bogus ", $myId, " before: ", ctx.cyclesLeft
  ctx.cyclesLeft.dec mutate(newCtx, loopBody, depth + 1)
  echo "bogus ", $myId, " after: ", ctx.cyclesLeft


  target.add quote do:
    for i in 0..`cyclesCount`:
      `loopBody`

proc initDefaultConfig(): MutationConfig {.compileTime.} = 
  MutationConfig(
    intDecls: 
      DeclConfig(prob: 0.3, copyInit: 0.20),
    intModifications:
      ProbConfig(prob: 0.6),
    floatDecls: 
      DeclConfig(prob: 0.2, copyInit: 0.09),
    floatModifications:
      ProbConfig(prob: 0.4),
    bogusLoop:
      BogusLoopConfig(prob: 0.2, bodyMutations: 10, depthLimit: 4)
    
  )

macro junkCode*(passes: static[int] = 1000, mcfg: static[MutationConfig] = initDefaultConfig()) = 
  result = nnkStmtList.newTree()
  var ctx = MutationContext()

  ctx.config = mcfg
  ctx.entropy = initRand(hash(CompileTime & CompileDate) and 0x7FFFFFFF)
  ctx.cyclesLeft = passes

  ctx.mutate(result)

when isMainModule:
  expandMacros:
    junkcode(50)

  echo "here"

