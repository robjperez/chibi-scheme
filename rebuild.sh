#!/bin/bash

cd ~/DATA2/src/chibi-scheme/
source ../emsdk/emsdk_env.sh

# Ideally this should be part of the makefile but...
# Let's go with this for now

# 1. Regenerate clibs.c
rm clibs.c
emmake make PLATFORM=emscripten CHIBI_DEPENDENCIES= CHIBI=./chibi-scheme-emscripten PREFIX= CFLAGS=-O2 SEXP_USE_DL=0 EXE=.bc SO=.bc STATICFLAGS=-shared CPPFLAGS="-DSEXP_USE_STRICT_TOPLEVEL_BINDINGS=1 -DSEXP_USE_ALIGNED_BYTECODE=1 -DSEXP_USE_STATIC_LIBS=1 -DSEXP_USE_STATIC_LIBS_NO_INCLUDE=0" clibs.c chibi-scheme-static.bc VERBOSE=1

# 2. Recompile eval.c  (eval.c has #include "clibs.c")

emcc -c -DSEXP_USE_STRICT_TOPLEVEL_BINDINGS=1 -DSEXP_USE_ALIGNED_BYTECODE=1 -DSEXP_USE_STATIC_LIBS=1 -DSEXP_USE_STATIC_LIBS_NO_INCLUDE=0 -Iinclude  -DSEXP_USE_INTTYPES -Wall -DSEXP_USE_DL=0 -g -g3 -O3 -O2 -fPIC -o eval.o eval.c

# 3. Regenerate wasm module (and js)
# preload_files is cache and generated with PRELOAD_FILES=$(find lib -type f \( -name "*.scm" -o -name "*.sld" \) -exec printf ' --preload-file %s' {} \;) echo $PRELOAD_FILES > preload_files
# If you add a new scm or sld, you need to regenate the file

PRELOAD_FILES=$(cat preload_files)
emcc -c -DSEXP_USE_STRICT_TOPLEVEL_BINDINGS=1 -DSEXP_USE_ALIGNED_BYTECODE=1 -DSEXP_USE_STATIC_LIBS=1 -DSEXP_USE_STATIC_LIBS_NO_INCLUDE=0 -Iinclude  -DSEXP_USE_INTTYPES -Wall -DSEXP_USE_DL=0 -g -g3 -O3 -O2 -fPIC -o main.o main.c

emcc -O0 main.o gc.o sexp.o bignum.o gc_heap.o opcodes.o vm.o eval.o simplify.o -o js/chibi.js -s ALLOW_MEMORY_GROWTH=1 -s MODULARIZE=1 -s EXPORT_NAME=\"Chibi\" -s EXPORTED_FUNCTIONS=@js/exported_functions.json $PRELOAD_FILES -s 'EXPORTED_RUNTIME_METHODS=["ccall", "cwrap"]' -s USE_SDL=2 -s WASM=1 --pre-js js/pre.js --post-js js/post.js -g -g3 -gsource-map 

