"use strict";

export const CONST_VAL = "const val";

const _hello = function(name) {
  return "private:Hello, " + name
};

export const open_hello = function(name) {
  return "open:Hello, " + name
};

export _not_const_hello = function(name) {
  return "not const private:Hello, " + name
};

// export function _not_const_hello(name) {
//   return "not const private:Hello, " + name
// };

console.log("finish Hello.js")
