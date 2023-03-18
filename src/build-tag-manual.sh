#!/bin/bash

rm -rf ../bin/$1 || true;
mkdir ../bin/$1;
docker run --name "openssl-wasm-manual-$1" -it --mount type=bind,src=`pwd`/../bin/$1,dst=/WASM --rm --entrypoint="bash" openssl-wasm