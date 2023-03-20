#!/bin/bash

echo "========================================"
echo "git checkout $1"
echo "========================================"

cd openssl
git checkout $1

echo "========================================"
echo "Setting Config"
echo "========================================"

# see https://github.com/emscripten-core/emscripten/blob/main/src/settings.js
LDFLAGS="\
  -s FILESYSTEM=1\
  -s MODULARIZE=1\
  -s EXPORTED_RUNTIME_METHODS=\"['callMain', 'FS', 'TTY', 'ccall']\"\
  -s INVOKE_RUN=0\
  -s EXIT_RUNTIME=1\
  -s EXPORT_ES6=0\
  -s USE_ES6_IMPORT_META=0\
  -s ALLOW_MEMORY_GROWTH=1\
  -s MALLOC=emmalloc\
  -s WASM_BIGINT=1\
  -s MAYBE_WASM2JS=1\
"

export LDFLAGS
export CC=emcc
export CXX=emcc

# Build OpenSSL for WebAssembly
source "/emsdk/emsdk_env.sh"
# default output in x86 anyway, and some gcc builds don't like `-m486`
sed -i 's/-m486 //' Configure

echo "========================================"
echo "Creating Makefile"
echo "========================================"

# see https://wiki.openssl.org/index.php/Compilation_and_Installation#Configure_Options
emconfigure ./config no-hw no-shared no-asm no-threads no-ssl3 no-dtls no-engine no-dso no-ui-console -static -no-afalgeng -DOPENSSL_NO_AFALGENG=1 -DSIG_DFL=0 -DSIG_IGN=0 -DHAVE_FORK=0 -DOPENSSL_NO_SPEED=1 -DNO_SYSLOG &> /WASM/output-configure-`date +"%F-%T"`.txt
sed -i 's/$(CROSS_COMPILE)//' Makefile

echo "========================================"
echo "Building OpenSSL"
echo "========================================"

make depend
emmake make &> /WASM/output-make-`date +"%F-%T"`.txt

if [ -f "/openssl/apps/openssl.wasm" ]; then
    echo "========================================"
    echo "Build Successful";
    echo "========================================"

    mv /openssl/apps/openssl /WASM/openssl.js
    mv /openssl/apps/openssl.wasm /WASM/openssl.wasm
else
    echo "========================================"
    echo "Build failed"
    echo "========================================"
fi