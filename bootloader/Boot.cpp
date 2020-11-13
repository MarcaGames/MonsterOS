typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

extern "C" {
  uint16_t ___BiosReadSector(uint16_t segment, uint16_t offset, uint8_t sectorsToRead, uint8_t cylinder, uint8_t sector, uint8_t head, uint8_t drive) {
    uint16_t res;
    __asm__ __volatile__ ("movl %3, %%es\n"
                          "int $0x13"
                            : "=a" (res)
                            : "a" ((0x02 << 0x8) | sectorsToRead),
                              "c" ((cylinder << 0x8) | sector),
                              "d" ((head << 0x8) | drive),
                              "r" (segment),
                              "b" (offset));
    return res;
  }

/*  uint16_t ___BiosWriteSector(uint16_t segment, uint16_t offset, uint8_t sectorsToWrite, uint8_t track, uint8_t sector, uint8_t head, uint8_t drive) {
    uint16_t res;
    __asm__ __volatile__ ("movl %3, %%es\n"
                          "int $0x13"
                            : "=a" (res)
                            : "a" ((0x03 << 0x8) | sectorsToWrite),
                              "c" ((track << 0x8) | sector),
                              "d" ((head << 0x8) | drive),
                              "r" (segment),
                              "b" (offset));
    return res;
  }*/

  void ___BiosPrint(const char* str) {
    char* pStr = const_cast<char*>(str);
    while (*pStr) {
      __asm__ __volatile__ ("int $0x10"
                              :
                              : "a" ((0x0E << 0x8) | *pStr++),
                                "b" (0x0000));
    }
  }

  void ___BootMain() {
    ___BiosPrint("Hello there FUCKER!");
  }
}
