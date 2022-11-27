# Code is based on https://forum.nim-lang.org/t/1305
# and https://forum.nim-lang.org/t/338
import macros, hashes

import rc4

type
  # Use a distinct string type so we won't recurse forever
  estring = distinct string

# Use a "strange" name
proc gkkaekgaEE(s: estring, key: int): string {.inline.} =
  # We need {.noinline.} here because otherwise C compiler
  # aggresively inlines this procedure for EACH string which results
  # in more assembly instructions
  var k = key
  result = string(s)
  for i in 0 ..< result.len:
    for f in [0, 8, 16, 24]:
      result[i] = chr(uint8(result[i]) xor uint8((k shr f) and 0xFF))
    k = k +% 1

proc rc4_shit*(s: estring, key: estring): string =
  RC4.fromRC4(key.string, s.string)


var encodedCounter {.compileTime.} = hash(CompileTime & CompileDate) and 0x7FFFFFFF

# Use a term-rewriting macro to change all string literals
macro encrypt*{s}(s: string{lit}): untyped =
  var 
    encodedStr = gkkaekgaEE(estring($s), encodedCounter)
    encodedKey = hash($encodedCounter)

  template genStuff(str, counter: untyped): untyped = 
    {.noRewrite.}:
      gkkaekgaEE(estring(`str`), `counter`)

  template genStuffRC4(str, counter: untyped): untyped = 
    {.noRewrite.}:
      rc4_shit(estring(`str`), `counter`)
  
  if ord(($s)[0]) mod 2 == 0:
    result = getAst(genStuff(encodedStr, encodedCounter))
  else:
    result = getAst(genStuffRC4(encodedStr, encodedKey))


  encodedCounter = (encodedCounter *% 16777619) and 0x7FFFFFFF