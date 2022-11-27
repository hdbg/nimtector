#pragma once
#include <cstdint>

namespace pe {
    struct DOS_Header
    {
        char e_magic[0x2];
        uint16_t e_cblp;
        uint16_t e_cp;
        uint16_t e_crlc;
        uint16_t e_cparhdr;
        uint16_t e_minalloc;
        uint16_t e_maxalloc;
        uint16_t e_ss;
        uint16_t e_sp;
        uint16_t e_csum;
        uint16_t e_ip;
        uint16_t e_cs;
        uint16_t e_lfarlc;
        uint16_t e_ovno;
        char e_res1[0x8];
        uint16_t e_oemid;
        uint16_t e_oeminfo;
        char e_res2[0x14];
        uint32_t e_lfanew;
    };

    enum class coff_machine:uint16_t
    {
        IMAGE_FILE_MACHINE_UNKNOWN = 0x0,
        IMAGE_FILE_MACHINE_AM33 = 0x1d3,
        IMAGE_FILE_MACHINE_AMD64 = 0x8664,
        IMAGE_FILE_MACHINE_ARM = 0x1c0,
        IMAGE_FILE_MACHINE_ARM64 = 0xaa64,
        IMAGE_FILE_MACHINE_ARMNT = 0x1c4,
        IMAGE_FILE_MACHINE_EBC = 0xebc,
        IMAGE_FILE_MACHINE_I386 = 0x14c,
        IMAGE_FILE_MACHINE_IA64 = 0x200,
        IMAGE_FILE_MACHINE_M32R = 0x9041,
        IMAGE_FILE_MACHINE_MIPS16 = 0x266,
        IMAGE_FILE_MACHINE_MIPSFPU = 0x366,
        IMAGE_FILE_MACHINE_MIPSFPU16 = 0x466,
        IMAGE_FILE_MACHINE_POWERPC = 0x1f0,
        IMAGE_FILE_MACHINE_POWERPCFP = 0x1f1,
        IMAGE_FILE_MACHINE_R4000 = 0x166,
        IMAGE_FILE_MACHINE_RISCV32 = 0x5032,
        IMAGE_FILE_MACHINE_RISCV64 = 0x5064,
        IMAGE_FILE_MACHINE_RISCV128 = 0x5128,
        IMAGE_FILE_MACHINE_SH3 = 0x1a2,
        IMAGE_FILE_MACHINE_SH3DSP = 0x1a3,
        IMAGE_FILE_MACHINE_SH4 = 0x1a6,
        IMAGE_FILE_MACHINE_SH5 = 0x1a8,
        IMAGE_FILE_MACHINE_THUMB = 0x1c2,
        IMAGE_FILE_MACHINE_WCEMIPSV2 = 0x169
    };

    enum class coff_characteristics:uint16_t
    {
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
    };



    struct COFF_Header
    {
        char magic[0x4];
        coff_machine machine;
        uint16_t numberOfSections;
        uint32_t timeDateStamp;
        uint32_t pointerToSymbolTable;
        uint32_t numberOfSymbols;
        uint16_t sizeOfOptionalHeader;
        coff_characteristics characteristics;
    };

    enum class pe_magic : uint16_t
    {
        PE_ROM_IMAGE = 0x107,
        PE_32BIT = 0x10b,
        PE_64BIT = 0x20b
    };

    enum class pe_subsystem : uint16_t
    {
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
    };

    enum class pe_dll_characteristics: uint16_t
    {
        _0001 = 0x1,
        _0002 = 0x2,
        _0004 = 0x4,
        _0008 = 0x8,
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
    };

    struct PE_Data_Directory_Entry
    {
        uint32_t virtualAddress;
        uint32_t size;
    };


    struct PE64_Optional_Header
    {
        pe_magic magic;
        uint8_t majorLinkerVersion;
        uint8_t minorLinkerVersion;
        uint32_t sizeOfCode;
        uint32_t sizeOfInitializedData;
        uint32_t sizeOfUninitializedData;
        uint32_t addressOfEntryPoint;
        uint32_t baseOfCode;
        uint64_t imageBase;
        uint32_t sectionAlignment;
        uint32_t fileAlignment;
        uint16_t majorOperatingSystemVersion;
        uint16_t minorOperatingSystemVersion;
        uint16_t majorImageVersion;
        uint16_t minorImageVersion;
        uint16_t majorSubsystemVersion;
        uint16_t minorSubsystemVersion;
        uint32_t win32VersionValue;
        uint32_t sizeOfImage;
        uint32_t sizeOfHeaders;
        uint32_t checkSum;
        pe_subsystem subsystem;
        pe_dll_characteristics dllCharacteristics;
        uint64_t sizeOfStackReserve;
        uint64_t sizeOfStackCommit;
        uint64_t sizeOfHeapReserve;
        uint64_t sizeOfHeapCommit;
        uint32_t loaderFlags;
        uint32_t numberOfRvaAndSizes;
        PE_Data_Directory_Entry exportTableEntry;
        PE_Data_Directory_Entry importTableEntry;
        PE_Data_Directory_Entry resourceTableEntry;
        PE_Data_Directory_Entry exceptionTableEntry;
        PE_Data_Directory_Entry certificateTableEntry;
        PE_Data_Directory_Entry baseRelocationTableEntry;
        PE_Data_Directory_Entry debugEntry;
        PE_Data_Directory_Entry architectureEntry;
        PE_Data_Directory_Entry globalPtrEntry;
        PE_Data_Directory_Entry tlsTableEntry;
        PE_Data_Directory_Entry loadConfigTableEntry;
        PE_Data_Directory_Entry boundImportEntry;
        PE_Data_Directory_Entry iatEntry;
        PE_Data_Directory_Entry delayImportDescriptorEntry;
        PE_Data_Directory_Entry clrRuntimeHeaderEntry;
        PE_Data_Directory_Entry reservedEntry;
    };

    struct PE32_Optional_Header
    {
        enum pe_magic magic;
        uint8_t majorLinkerVersion;
        uint8_t minorLinkerVersion;
        uint32_t sizeOfCode;
        uint32_t sizeOfInitializedData;
        uint32_t sizeOfUninitializedData;
        uint32_t addressOfEntryPoint;
        uint32_t baseOfCode;
        uint32_t baseOfData;
        uint32_t imageBase;
        uint32_t sectionAlignment;
        uint32_t fileAlignment;
        uint16_t majorOperatingSystemVersion;
        uint16_t minorOperatingSystemVersion;
        uint16_t majorImageVersion;
        uint16_t minorImageVersion;
        uint16_t majorSubsystemVersion;
        uint16_t minorSubsystemVersion;
        uint32_t win32VersionValue;
        uint32_t sizeOfImage;
        uint32_t sizeOfHeaders;
        uint32_t checkSum;
        enum pe_subsystem subsystem;
        enum pe_dll_characteristics dllCharacteristics;
        uint32_t sizeOfStackReserve;
        uint32_t sizeOfStackCommit;
        uint32_t sizeOfHeapReserve;
        uint32_t sizeOfHeapCommit;
        uint32_t loaderFlags;
        uint32_t numberOfRvaAndSizes;
        struct PE_Data_Directory_Entry exportTableEntry;
        struct PE_Data_Directory_Entry importTableEntry;
        struct PE_Data_Directory_Entry resourceTableEntry;
        struct PE_Data_Directory_Entry exceptionTableEntry;
        struct PE_Data_Directory_Entry certificateTableEntry;
        struct PE_Data_Directory_Entry baseRelocationTableEntry;
        struct PE_Data_Directory_Entry debugEntry;
        struct PE_Data_Directory_Entry architectureEntry;
        struct PE_Data_Directory_Entry globalPtrEntry;
        struct PE_Data_Directory_Entry tlsTableEntry;
        struct PE_Data_Directory_Entry loadConfigTableEntry;
        struct PE_Data_Directory_Entry boundImportEntry;
        struct PE_Data_Directory_Entry iatEntry;
        struct PE_Data_Directory_Entry delayImportDescriptorEntry;
        struct PE_Data_Directory_Entry clrRuntimeHeaderEntry;
        struct PE_Data_Directory_Entry reservedEntry;
    };

    enum class pe_section_flags:uint32_t
    {
        RESERVED_0001 = 0x1,
        RESERVED_0002 = 0x2,
        RESERVED_0004 = 0x4,
        TYPE_NO_PAD = 0x8,
        RESERVED_0010 = 0x10,
        CNT_CODE = 0x20,
        CNT_INITIALIZED_DATA = 0x40,
        CNT_UNINITIALIZED_DATA = 0x80,
        LNK_OTHER = 0x100,
        LNK_INFO = 0x200,
        RESERVED_0400 = 0x400,
        LNK_REMOVE = 0x800,
        LNK_COMDAT = 0x1000,
        GPREL = 0x8000,
        MEM_PURGEABLE = 0x10000,
        MEM_16BIT = 0x20000,
        MEM_LOCKED = 0x40000,
        MEM_PRELOAD = 0x80000,
        LNK_NRELOC_OVFL = 0x1000000,
        MEM_DISCARDABLE = 0x2000000,
        MEM_NOT_CACHED = 0x4000000,
        MEM_NOT_PAGED = 0x8000000,
        MEM_SHARED = 0x10000000,
        MEM_EXECUTE = 0x20000000,
        MEM_READ = 0x40000000,
        MEM_WRITE = 0x80000000
    };


    struct Section_Header
    {
        char name[0x8];
        uint32_t virtualSize;
        uint32_t virtualAddress;
        uint32_t sizeOfRawData;
        uint32_t pointerToRawData;
        uint32_t pointerToRelocations;
        uint32_t pointerToLineNumbers;
        uint16_t numberOfRelocations;
        uint16_t numberOfLineNumbers;
        pe_section_flags characteristics;
    };

    
    namespace tables {
        struct _export
        {
            uint32_t exportFlags;
            uint32_t timeDateStamp;
            uint16_t majorVersion;
            uint16_t minorVersion;
            uint32_t nameRva;
            uint32_t ordinalBase;
            uint32_t addressTableEntries;
            uint32_t numberOfNamePointers;
            uint32_t exportAddressTableRva;
            uint32_t namePointerRva;
            uint32_t ordinalTableRva;
        };

        struct import
        {
            uint32_t importLookupTableRva;
            uint32_t timeDateStamp;
            uint32_t forwarderChain;
            uint32_t nameRva;
            uint32_t importAddressTableRva;
        };


    };

};

