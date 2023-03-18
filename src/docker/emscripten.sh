#!/bin/bash

cd openssl
git checkout $1

LDFLAGS="\
    -s STRICT=1 \
    -s FILESYSTEM=1\
    -s INVOKE_RUN=0\
    -s EXIT_RUNTIME=1\
    -s EXPORT_ES6=1 \
    -s MODULARIZE=1\
    -s EXPORTED_RUNTIME_METHODS=\"['callMain', 'FS', 'TTY', 'ccall']\"\
    -s EXPORT_NAME='openssl-wasm'\
    -s USE_ES6_IMPORT_META=0\
    -s ALLOW_MEMORY_GROWTH=1\
    -s MALLOC=emmalloc"

export LDFLAGS
export CC=emcc
export CXX=emcc

# Build OpenSSL for WebAssembly
source "/emsdk/emsdk_env.sh"
# default output in x86 anyway, and some gcc builds don't like `-m486`
sed -i 's/-m486 //' Configure
# see https://wiki.openssl.org/index.php/Compilation_and_Installation#Configure_Options
emconfigure ./config no-hw no-shared no-asm no-threads no-ssl3 no-dtls no-engine no-dso no-ui-console -static -no-afalgeng -DOPENSSL_NO_AFALGENG=1 -DSIG_DFL=0 -DSIG_IGN=0 -DHAVE_FORK=0 -DOPENSSL_NO_SPEED=1 -DNO_SYSLOG &> /WASM/output-configure-`date +"%F-%T"`.txt
sed -i 's/$(CROSS_COMPILE)//' Makefile
make depend
emmake make &> /WASM/output-make-`date +"%F-%T"`.txt

mv /openssl/apps/openssl /WASM/openssl.js
mv /openssl/apps/openssl.wasm /WASM/openssl.wasm