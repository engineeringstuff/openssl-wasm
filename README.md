# openssl-wasm
## What is this?
This repository holds the source files and generated WebAssembly (WASM) output for OpenSSL compiled to WASM.

## Versioning
The versions here are linked to OpenSSL versions, so if you `require('openssl-wasm')` and get OpenSSL `3.1.0`, but you want OpenSSL `1.1.1` then you should install that with `npm install openssl-wasm@1.1.1`

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

## Using it
You can this directly from javascript using node or even in the web-browser, we use the default `emscripten` settings so that it targets as many platforms as possible and should be usable with [`wasm2js`](https://github.com/thlorenz/wasm2js)

First install this library
```bash
npm install openssl-wasm
```

Then you can start with something like this:

```javascript
import opensslWASM from 'openssl-wasm';

const module = {
	print: function (text) {
		console.log(`stdout: ${text}`);
	},
	printErr: function (text) {
		console.error(`stderr: ${text}`);
	}
};

(async () => {
	const openSSL = await opensslWASM(module);
	await openSSL.callMain(['version']);
})().catch((errorDetail) => {
	console.error(`stderr: ${errorDetail}`);
});
```

### Typescript
If you're looking for an easy, drop-in Typescript ambient module, then you can use something like the following, but you'll need to install `@types/emscripten` first.

```typescript
declare module 'openssl-wasm' {
	import { EmscriptenModule, EmscriptenModuleFactory } from '@types/emscripten';

	interface CallMain extends EmscriptenModule {
		ccall: typeof ccall;
		callMain: typeof ccall;
	}

	function opensslWASM(module: EmscriptenModule<CallMain>): EmscriptenModuleFactory<CallMain>;

	export default opensslWASM;
}

```