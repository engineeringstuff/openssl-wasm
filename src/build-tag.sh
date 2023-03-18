#!/bin/bash

mkdir -p ../bin
mkdir -p ../bin/$1;
docker run --name "openssl-wasm-$1" --mount type=bind,src=`pwd`/../bin/$1,dst=/WASM --rm openssl-wasm $1
