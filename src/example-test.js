const opensslWASM = require("./openssl.js");

// See https://emscripten.org/docs/api_reference/module.html
var Module = {
  print: function (text) {
    console.log(`stdout: ${text}`);
  },
  printErr: function (text) {
    console.error(`stderr: ${text}`);
  },
};

(async () => {
  const openSSL = await opensslWASM(Module);
  await openSSL.callMain(["version"]);
})().catch((errorDetail) => {
  console.error(`stderr: ${errorDetail}`);
});
