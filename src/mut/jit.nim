import std/[macros]
import catnip/x64assembler

type
  Operations* {.pure.} = enum
    Copy
    DeclArg
    Ret
    Add
    Sub
    Mul
    Xor
    

proc semCheck(body: NimNode) {.compileTime.} = discard

macro jit*(name, body: untyped) = 
  body.expectKind nnkFuncDef
  body.semCheck

when isMainModule:
  dumpAstGen:
    0