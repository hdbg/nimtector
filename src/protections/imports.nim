import std/hashes
import pe

type ExportHash* = Hash

proc clearStr(s: var string) = 
  for c in s.mitems:
    c = '#'

  `=destroy`(s)

template iterateExports(module: pointer, body: untyped) = 
  let 
    dosPtr = cast[ptr pe.DOS_Header](module)
    coffPtr = cast[ptr pe.COFF_Header](cast[uint](module) + dosPtr.e_lfanew)

  let peMagicPtr = cast[ptr pe_magic](cast[int](coffPtr) + sizeof(COFF_Header))

  let section = if peMagicPtr[] == pe_magic.PE_32BIT:
    cast[ptr PE32_Optional_Header](cast[int](coffPtr) + sizeof(COFF_Header)).exportTableEntry.virtualAddress
  else:
    cast[ptr PE64_Optional_Header](cast[int](coffPtr) + sizeof(COFF_Header)).exportTableEntry.virtualAddress

  let exportTablePtr = cast[ptr PE_Export_Table](section + cast[uint32](module))

  let 
    namesArray = cast[ptr char](cast[uint32](module) + exportTablePtr.nameTablePtr)
    ordinalsArray = cast[ptr uint16](cast[uint32](module) + exportTablePtr.ordinalTablePtr)
    addressArray = cast[ptr pointer](cast[uint32](module) + exportTablePtr.adressTablePtr)

  for i in 0..<(exportTablePtr.namePointersCount):
    var 
      currentName {.inject.}: string = $cast[cstring](cast[int](namesArray) + 4 * i.int)
      currentOrdinal {.inject.} = cast[type(ordinalsArray)](cast[int](ordinalsArray) + 2 * i.int)[]
      currentAddr {.inject.} = cast[ptr int](cast[int](addressArray) + 4 * currentOrdinal.int)[]

    body

proc findExport( module: pointer, hashName: ExportHash): pointer = 
  result = nil

  iterateExports(module):
    let currentHash = hash currentName

    if currentHash != hashName:
      clearStr(currentName)
      continue

    return cast[pointer](currentAddr + cast[int](module))


proc getPeb(): pointer = 
  var resultVar: pointer

  asm """
    mov `resultVar`, gs:[0x60]
  """

  return resultVar

proc findKernel(): pointer = 
  # https://www.vergiliusproject.com/kernels/x64/Windows%2011/22H2%20(2022%20Update)/_PEB

  # https://www.vergiliusproject.com/kernels/x64/Windows%2011/22H2%20(2022%20Update)/_PEB_LDR_DATA
  let 
    ldrData = cast[ptr pointer](cast[int](getPeb()) + 0x18)[]

    inLoad = cast[ptr pointer](cast[int](ldrData) + 0x10)[]

  var currentEntry = inLoad

  currentEntry = cast[ptr pointer](currentEntry)[]
  currentEntry = cast[ptr pointer](currentEntry)[]

  return cast[ptr pointer](cast[int](currentEntry) + 0x30)[]

proc findNt(): pointer = 
  # https://www.vergiliusproject.com/kernels/x64/Windows%2011/22H2%20(2022%20Update)/_PEB

  # https://www.vergiliusproject.com/kernels/x64/Windows%2011/22H2%20(2022%20Update)/_PEB_LDR_DATA
  let 
    ldrData = cast[ptr pointer](cast[int](getPeb()) + 0x18)[]

    inLoad = cast[ptr pointer](cast[int](ldrData) + 0x10)[]

  var currentEntry = inLoad

  currentEntry = cast[ptr pointer](currentEntry)[]

  return cast[ptr pointer](cast[int](currentEntry) + 0x30)[]



# api

converter toExportHash*(x: string): ExportHash {.compileTime.} = ExportHash(x.hash)
proc eh*(x: string): ExportHash {.compileTime.} = ExportHash(x.hash)

proc dllImport*(dll: string, importName: ExportHash): pointer = 
  let 
    kernelModule = findKernel()
    loadLib = cast[proc(n: cstring): pointer {.stdcall.}](findExport(kernelModule, eh"LoadLibraryA"))

  if loadLib == nil:
    quit(0)

  result = findExport(loadLib(dll), importName)

  if result == nil:
    quit(-1)

proc kernelImport*(importName: ExportHash): pointer = 
  let 
    kernelModule = findKernel()

  result = findExport(kernelModule,  importName)