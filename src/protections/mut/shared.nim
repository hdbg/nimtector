import std/[random, hashes, macros]
var 
  entropy* {.compileTime.} = initRand(hash(CompileTime & CompileDate) and 0x7FFFFFFF)
  uniqueCounter {.compileTime.} = 0

template loop*(times: typed, b: untyped) = 
  for _ in 0..times:
    b

proc unique*(prefix: string, add_random = false): NimNode {.compileTime.} = 
  var resulting: string = prefix & "_" & $uniqueCounter
  uniqueCounter.inc

  if add_random:
    resulting.add "_" & $(entropy.rand(0xffff))

  newIdentNode(resulting)

proc choice*[T](x: openArray[T]): T {.compileTime.} = 
  return x[entropy.rand(x.high)]