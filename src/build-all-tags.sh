#!/bin/bash

./build-image.sh

mkdir -p ../bin

N=8

buildOpenSSLWASM() {
    # $1 is the hash
    # $2 is the tag/branch
    mkdir -p ../bin/$2;

    if [ ! -f "../bin/$2/$1.hash" ]; then
        touch "../bin/$2/$1.hash"

        echo "Building $2";
        ./build-tag.sh $2;
    else
        echo "Hash already exists ../bin/$2/$1.hash"
    fi
}

# Build each tag
while IFS= read -r currentLine
do
    ((i=i%N)); ((i++==0)) && wait
    buildOpenSSLWASM $currentLine &
done < <(git ls-remote --tags https://github.com/openssl/openssl | sed -e 's/refs\/tags\///' | grep '[oO]pen[SsLl0-9_.-]*[a-z0-9]$' )

# Build each branch
while IFS= read -r currentLine
do
    ((i=i%N)); ((i++==0)) && wait
    buildOpenSSLWASM $currentLine &
done < <(git ls-remote --heads https://github.com/openssl/openssl | sed -e 's/refs\/heads\///' | grep '[oO]pen[SsLl].*$' )

wait;

echo "Builds complete"