"""
Simple test script for a shared object
"""

import sys
from cffi import FFI
ffi = FFI()
ffi.cdef("""
typedef unsigned int GoUint32;
extern GoUint32 Version();
extern char* VersionString();
extern void MyFree(void* p0);
""")
try:
    lib = ffi.dlopen(sys.argv[1])
except:
    lib = ffi.dlopen("./"+sys.argv[1])

# print plugin version
version32 = lib.Version()
version_major = ((version32 & 0xFF << 16) >> 16)
version_minor = ((version32 & 0xFF << 8) >> 8)
version_patch = ((version32 & 0xFF << 00) >> 0)
print("decoded semvar:", f'{version_major}.{version_minor}.{version_patch}')

# get version string and print
x = lib.VersionString()
print("version string:", ffi.string(x).decode())
lib.MyFree(x)

