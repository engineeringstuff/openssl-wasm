FROM ubuntu:latest

# Reference: https://github.com/cryptool-org/openssl-webterm/blob/master/emscr/builds/openssl/build.sh
# Reference: https://github.com/TrueBitFoundation/wasm-ports/blob/master/Dockerfile
# Reference: https://askubuntu.com/questions/891630/how-to-install-the-latest-emscripten-on-ubuntu-using-command-line

SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update \
    && apt-get install -y git wget sudo curl build-essential cmake python3 xutils-dev

# Clone emsdk
RUN git clone https://github.com/juj/emsdk \
    && cd emsdk \
    && ./emsdk update-tags \
    && ./emsdk install latest \
    && ./emsdk activate latest

# Clone OpenSSL source code
RUN git clone https://github.com/openssl/openssl.git

COPY ./docker/emscripten.sh .

RUN chmod +x /emscripten.sh

VOLUME [ "/WASM" ]

ENTRYPOINT [ "./emscripten.sh" ]

CMD ['openssl-3.1']