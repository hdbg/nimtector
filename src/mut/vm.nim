import std/[macros, tables]
import shared


# Intermidiate Representation
type
  IROp {.pure.} = enum
    MovFrom               # Copy from stack by offset
    MovTo                 # Copy to stack by offset
    

#[
  Steps:
    - Walk through all the stack allocation and assign offset to each symbol depending on its size
    - Convert all expressions to IR
    - Convert control flow to basic jumps
]#

type
  VarEntry = object
    offset: int
    name, kind: NimNode

  CompilationCtx = ref object
    vars: seq[VarEntry]

when isMainModule:
  dumpAstGen:
    proc x = 
      let 
        d = 4
        b = VarEntry()
      var 
        t = 4
        y = 10

      t += 10

      t = t + y * 10 / 2


