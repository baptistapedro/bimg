package main

import (
  "os"
  "github.com/h2non/bimg"
)

func main() {
	bimg.Read(os.Args[1])
	return
}
