#/usr/bin/env bash

clang -framework IOKit -framework CoreGraphics -arch arm64 -arch x86_64 -o toggle-caps capslock.c
