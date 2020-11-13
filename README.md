# MonsterOS

## How to build
First make sure you have these compilers and linker(s):
- i686-elf-gcc
- nasm
- gnu linker
Then edit the `build.sh` file to give the correct paths to the compilers and linker(s).
If you have `qemu-system-i386` available you should be able to uncomment that line and
it will auto start qemu when you run the build script.
