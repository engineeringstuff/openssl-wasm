# openssl-wasm
## What is this?
This repository holds the source files and generated WebAssembly (WASM) output for OpenSSL compiled to WASM.

## Getting Started
The following assumes that you are working in a `bash` terminal with `docker` installed and available.

1. Build the `openssl-wasm` docker image 
	* Run `./src/build-image.sh`
	* The image expects a volume to be mounted at `/WASM`
2. Build a specific version of OpenSSL
	* Run `docker run openssl-wasm OpenSSL_1_1_1-stable` if you want to build `OpenSSL_1_1_1-stable` 
	* You can use any tag or branch from the OpenSSL GitHub repo
3. Build all OpenSSL tags and branches
	* Run `./src/build-all-tags.sh`
	* It takes a while

## How does it work?
**tldr;** it uses `empscripten` to build the specified OpenSSL tag or branch in a container, and the WASM output is written to a mounted volume (a local folder).

1. The `Dockerfile`
	* Installs dependencies
	* Installs `emscripten` SDK (`emsdk`)
	* Clones the OpenSSL repo into the image
	* Copies the build script (`./src/docker/emscripten.sh`) on build
2. The `openssl-wasm` image
	* Will `git checkout` the given a tag or branch name
	* Configure `emsdk` and build tooling
	* Builds OpenSSL using `emmake make`
	* Copies the output to the mounted volume/folder
3. The `*.wasm` output
	* Should be copied to a local folder
	* Should have an `openssl.js` file (Module) to load the WebAssembly
	* Should have an `openssl.wasm` file which is the WebAssembly version of OpenSSL