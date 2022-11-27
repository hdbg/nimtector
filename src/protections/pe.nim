type
  DOS_Header* {.bycopy.} = object
    e_magic*: array[0x2, char]
    e_cblp*: uint16
    e_cp*: uint16
    e_crlc*: uint16
    e_cparhdr*: uint16
    e_minalloc*: uint16
    e_maxalloc*: uint16
    e_ss*: uint16
    e_sp*: uint16
    e_csum*: uint16
    e_ip*: uint16
    e_cs*: uint16
    e_lfarlc*: uint16
    e_ovno*: uint16
    e_res1*: array[0x8, char]
    e_oemid*: uint16
    e_oeminfo*: uint16
    e_res2*: array[0x14, char]
    e_lfanew*: uint32

## !!!Ignored construct:  enum class coff_machine : uint16 { IMAGE_FILE_MACHINE_UNKNOWN = 0x0 , IMAGE_FILE_MACHINE_AM33 = 0x1d3 , IMAGE_FILE_MACHINE_AMD64 = 0x8664 , IMAGE_FILE_MACHINE_ARM = 0x1c0 , IMAGE_FILE_MACHINE_ARM64 = 0xaa64 , IMAGE_FILE_MACHINE_ARMNT = 0x1c4 , IMAGE_FILE_MACHINE_EBC = 0xebc , IMAGE_FILE_MACHINE_I386 = 0x14c , IMAGE_FILE_MACHINE_IA64 = 0x200 , IMAGE_FILE_MACHINE_M32R = 0x9041 , IMAGE_FILE_MACHINE_MIPS16 = 0x266 , IMAGE_FILE_MACHINE_MIPSFPU = 0x366 , IMAGE_FILE_MACHINE_MIPSFPU16 = 0x466 , IMAGE_FILE_MACHINE_POWERPC = 0x1f0 , IMAGE_FILE_MACHINE_POWERPCFP = 0x1f1 , IMAGE_FILE_MACHINE_R4000 = 0x166 , IMAGE_FILE_MACHINE_RISCV32 = 0x5032 , IMAGE_FILE_MACHINE_RISCV64 = 0x5064 , IMAGE_FILE_MACHINE_RISCV128 = 0x5128 , IMAGE_FILE_MACHINE_SH3 = 0x1a2 , IMAGE_FILE_MACHINE_SH3DSP = 0x1a3 , IMAGE_FILE_MACHINE_SH4 = 0x1a6 , IMAGE_FILE_MACHINE_SH5 = 0x1a8 , IMAGE_FILE_MACHINEHUMB = 0x1c2 , IMAGE_FILE_MACHINE_WCEMIPSV2 = 0x169 } ;
## Error: token expected: ; but got: :!!!

## !!!Ignored construct:  enum class coff_characteristics : uint16 { IMAGE_FILE_RELOCS_STRIPPED = 0x1 , IMAGE_FILE_EXECUTABLE_IMAGE = 0x2 , IMAGE_FILE_LINE_NUMS_STRIPPED = 0x4 , IMAGE_FILE_LOCAL_SYMS_STRIPPED = 0x8 , IMAGE_FILE_AGGRESIVE_WSRIM = 0x10 , IMAGE_FILE_LARGE_ADDRESS_AWARE = 0x20 , IMAGE_FILE_BYTES_REVERSED_LO = 0x80 , IMAGE_FILE_32BIT_MACHINE = 0x100 , IMAGE_FILE_DEBUG_STRIPPED = 0x200 , IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP = 0x400 , IMAGE_FILE_NET_RUN_FROM_SWAP = 0x800 , IMAGE_FILE_SYSTEM = 0x1000 , IMAGE_FILE_DLL = 0x2000 , IMAGE_FILE_UP_SYSTEM_ONLY = 0x4000 , IMAGE_FILE_BYTES_REVERSED_HI = 0x8000 } ;
## Error: token expected: ; but got: :!!!

type
  coff_characteristics* {.pure, size:sizeof(uint16).} = enum
    IMAGE_FILE_RELOCS_STRIPPED = 0x1,
    IMAGE_FILE_EXECUTABLE_IMAGE = 0x2,
    IMAGE_FILE_LINE_NUMS_STRIPPED = 0x4,
    IMAGE_FILE_LOCAL_SYMS_STRIPPED = 0x8,
    IMAGE_FILE_AGGRESIVE_WS_TRIM = 0x10,
    IMAGE_FILE_LARGE_ADDRESS_AWARE = 0x20,
    IMAGE_FILE_BYTES_REVERSED_LO = 0x80,
    IMAGE_FILE_32BIT_MACHINE = 0x100,
    IMAGE_FILE_DEBUG_STRIPPED = 0x200,
    IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP = 0x400,
    IMAGE_FILE_NET_RUN_FROM_SWAP = 0x800,
    IMAGE_FILE_SYSTEM = 0x1000,
    IMAGE_FILE_DLL = 0x2000,
    IMAGE_FILE_UP_SYSTEM_ONLY = 0x4000,
    IMAGE_FILE_BYTES_REVERSED_HI = 0x8000

type
  COFF_Header* {.bycopy.} = object
    magic*: array[0x4, char]
    machine*: uint16
    numberOfSections*: uint16
    timeDateStamp*: uint32
    pointerToSymbolTable*: uint32
    numberOfSymbols*: uint32
    sizeOfOptionalHeader*: uint16
    characteristics*: coff_characteristics


## !!!Ignored construct:  enum class pe_magic : uint16 { PE_ROM_IMAGE = 0x107 , PE_32BIT = 0x10b , PE_64BIT = 0x20b } ;
## Error: token expected: ; but got: :!!!

## !!!Ignored construct:  enum class pe_subsystem : uint16 { UNKNOWN = 0x0 , NATIVE = 0x1 , WINDOWS_GUI = 0x2 , WINDOWS_CUI = 0x3 , OS2_CUI = 0x5 , POSIX_CUI = 0x7 , NATIVE_WINDOWS = 0x8 , WINDOWS_CE_GUI = 0x9 , EFI_APPLICATION = 0xa , EFI_BOOT_SERVICE_DRIVER = 0xb , EFI_RUNTIME_DRIVER = 0xc , EFI_ROM = 0xd , XBOX = 0xe , WINDOWS_BOOT_APPLICATION = 0x10 } ;
## Error: token expected: ; but got: :!!!

## !!!Ignored construct:  enum class pe_dll_characteristics : uint16 { _0001 = 0x1 , _0002 = 0x2 , _0004 = 0x4 , _0008 = 0x8 , HIGH_ENTROPY_VA = 0x20 , DYNAMIC_BASE = 0x40 , FORCE_INTEGRITY = 0x80 , NX_COMPAT = 0x100 , NO_ISOLATION = 0x200 , NO_SEH = 0x400 , NO_BIND = 0x800 , APPCONTAINER = 0x1000 , WDM_DRIVER = 0x2000 , GUARD_CF = 0x4000 , TERMINAL_SERVER_AWARE = 0x8000 } ;
## Error: token expected: ; but got: :!!!

type
  PE_Data_Directory_Entry* {.bycopy.} = object
    virtualAddress*: uint32
    size*: uint32

  pe_magic* {.pure, size:sizeof(uint16).} = enum
    PE_ROM_IMAGE = 0x107,
    PE_32BIT = 0x10b,
    PE_64BIT = 0x20b

  pe_subsystem* {.pure, size:sizeof(uint16).} = enum
    UNKNOWN = 0x0,
    NATIVE = 0x1,
    WINDOWS_GUI = 0x2,
    WINDOWS_CUI = 0x3,
    OS2_CUI = 0x5,
    POSIX_CUI = 0x7,
    NATIVE_WINDOWS = 0x8,
    WINDOWS_CE_GUI = 0x9,
    EFI_APPLICATION = 0xa,
    EFI_BOOT_SERVICE_DRIVER = 0xb,
    EFI_RUNTIME_DRIVER = 0xc,
    EFI_ROM = 0xd,
    XBOX = 0xe,
    WINDOWS_BOOT_APPLICATION = 0x10

  pe_dll_characteristics* {.pure, size:sizeof(uint16).} = enum
    # _0001 = 0x1,
    # _0002 = 0x2,
    # _0004 = 0x4,
    # _0008 = 0x8,
    HIGH_ENTROPY_VA = 0x20,
    DYNAMIC_BASE = 0x40,
    FORCE_INTEGRITY = 0x80,
    NX_COMPAT = 0x100,
    NO_ISOLATION = 0x200,
    NO_SEH = 0x400,
    NO_BIND = 0x800,
    APPCONTAINER = 0x1000,
    WDM_DRIVER = 0x2000,
    GUARD_CF = 0x4000,
    TERMINAL_SERVER_AWARE = 0x8000

  PE64_Optional_Header* {.bycopy.} = object
    magic*: pe_magic
    majorLinkerVersion*: uint8
    minorLinkerVersion*: uint8
    sizeOfCode*: uint32
    sizeOfInitializedData*: uint32
    sizeOfUninitializedData*: uint32
    addressOfEntryPoint*: uint32
    baseOfCode*: uint32
    imageBase*: uint64
    sectionAlignment*: uint32
    fileAlignment*: uint32
    majorOperatingSystemVersion*: uint16
    minorOperatingSystemVersion*: uint16
    majorImageVersion*: uint16
    minorImageVersion*: uint16
    majorSubsystemVersion*: uint16
    minorSubsystemVersion*: uint16
    win32VersionValue*: uint32
    sizeOfImage*: uint32
    sizeOfHeaders*: uint32
    checkSum*: uint32
    subsystem*: pe_subsystem
    dllCharacteristics*: pe_dll_characteristics
    sizeOfStackReserve*: uint64
    sizeOfStackCommit*: uint64
    sizeOfHeapReserve*: uint64
    sizeOfHeapCommit*: uint64
    loaderFlags*: uint32
    numberOfRvaAndSizes*: uint32
    exportTableEntry*: PE_Data_Directory_Entry
    importTableEntry*: PE_Data_Directory_Entry
    resourceTableEntry*: PE_Data_Directory_Entry
    exceptionTableEntry*: PE_Data_Directory_Entry
    certificateTableEntry*: PE_Data_Directory_Entry
    baseRelocationTableEntry*: PE_Data_Directory_Entry
    debugEntry*: PE_Data_Directory_Entry
    architectureEntry*: PE_Data_Directory_Entry
    globalPtrEntry*: PE_Data_Directory_Entry
    tlsTableEntry*: PE_Data_Directory_Entry
    loadConfigTableEntry*: PE_Data_Directory_Entry
    boundImportEntry*: PE_Data_Directory_Entry
    iatEntry*: PE_Data_Directory_Entry
    delayImportDescriptorEntry*: PE_Data_Directory_Entry
    clrRuntimeHeaderEntry*: PE_Data_Directory_Entry
    reservedEntry*: PE_Data_Directory_Entry

  PE32_Optional_Header* {.bycopy.} = object
    magic: pe_magic
    majorLinkerVersion*: uint8
    minorLinkerVersion*: uint8
    sizeOfCode*: uint32
    sizeOfInitializedData*: uint32
    sizeOfUninitializedData*: uint32
    addressOfEntryPoint*: uint32
    baseOfCode*: uint32
    baseOfData*: uint32
    imageBase*: uint32
    sectionAlignment*: uint32
    fileAlignment*: uint32
    majorOperatingSystemVersion*: uint16
    minorOperatingSystemVersion*: uint16
    majorImageVersion*: uint16
    minorImageVersion*: uint16
    majorSubsystemVersion*: uint16
    minorSubsystemVersion*: uint16
    win32VersionValue*: uint32
    sizeOfImage*: uint32
    sizeOfHeaders*: uint32
    checkSum*: uint32
    subsystem*: pe_subsystem
    dllCharacteristics*: pe_dll_characteristics
    sizeOfStackReserve*: uint32
    sizeOfStackCommit*: uint32
    sizeOfHeapReserve*: uint32
    sizeOfHeapCommit*: uint32
    loaderFlags*: uint32
    numberOfRvaAndSizes*: uint32
    exportTableEntry*: PE_Data_Directory_Entry
    importTableEntry*: PE_Data_Directory_Entry
    resourceTableEntry*: PE_Data_Directory_Entry
    exceptionTableEntry*: PE_Data_Directory_Entry
    certificateTableEntry*: PE_Data_Directory_Entry
    baseRelocationTableEntry*: PE_Data_Directory_Entry
    debugEntry*: PE_Data_Directory_Entry
    architectureEntry*: PE_Data_Directory_Entry
    globalPtrEntry*: PE_Data_Directory_Entry
    tlsTableEntry*: PE_Data_Directory_Entry
    loadConfigTableEntry*: PE_Data_Directory_Entry
    boundImportEntry*: PE_Data_Directory_Entry
    iatEntry*: PE_Data_Directory_Entry
    delayImportDescriptorEntry*: PE_Data_Directory_Entry
    clrRuntimeHeaderEntry*: PE_Data_Directory_Entry
    reservedEntry*: PE_Data_Directory_Entry

  PE_Section* = object
    name*: array[8, char]
    virtualSize*: uint32

  PE_Export_Table* {.packed.} = object
    exportFlags: uint32
    stamp*: uint32
    major*: uint16
    minor*: uint16
    nameRVA*: uint32
    ordinalBase*: uint32
    adressCount*: uint32
    namePointersCount*: uint32
    adressTablePtr*: uint32
    nameTablePtr*: uint32
    ordinalTablePtr*: uint32