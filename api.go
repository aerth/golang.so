package main

/*
#include <stdlib.h>
*/
import "C"

import (
	"fmt"
	"log"
	"unsafe"
)

var (
	built        string
	gitcommit    string
	versionMajor uint8 = 0
	versionMinor uint8 = 0
	versionPatch uint8 = 1
)

func init() {
	log.SetFlags(0)
}

//export Version
func Version() uint32 {
	v := 0 |
		uint32(versionMajor)<<16 |
		uint32(versionMinor)<<8 |
		uint32(versionPatch)<<0
	return v
}

//export VersionString
func VersionString() *C.char {
	return C.CString(fmt.Sprintf("%d.%d.%d-%s", versionMajor, versionMinor, versionPatch, gitcommit))
}

//export MyFree
func MyFree(ptr unsafe.Pointer) {
	C.free(ptr)
}
