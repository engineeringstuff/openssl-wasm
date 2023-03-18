#!/bin/bash

DOCKER_BUILDKIT=0 docker build --pull --no-cache --tag openssl-wasm .