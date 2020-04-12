#!/bin/env python3
from ctypes import cdll, create_string_buffer, cast, c_char_p

import sys
lib = cdll.LoadLibrary("./"+sys.argv[1])
if lib is None:
    print ("cant load so")
    quit(111)

# print plugin version
version32 = lib.Version()
version_major = ((version32 & 0xFF << 16) >> 16)
version_minor = ((version32 & 0xFF << 8) >> 8)
version_patch = ((version32 & 0xFF << 00) >> 0)
print("decoded semvar:", f'{version_major}.{version_minor}.{version_patch}')

buf = lib.VersionString()
print("version string:", cast(buf, c_char_p).value.decode())
lib.MyFree(buf)
