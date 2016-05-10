function outer() {
  var a = 1;

  a = 2;
  var b = inner();
  a = 3;

  return b;
  function inner() {
    return a;
  }
}

console.log("outer() : " + outer()); // 2

var f_val = 20;
function f(shouldInitialize: boolean) {
  if (shouldInitialize) {
    var f_val = 10;
  }
  return f_val;
}
console.log("f(true) : " + f(true));
console.log("f(false) : " + f(false));
console.log("f_val : " + f_val);

/*
for (var i = 0; i < 10; i++) {
  setTimeout(function() {console.log(i); }, 100 * i);
}

for (var i = 0; i < 10; i++) {
  (function(i) {
    setTimeout(function() { console.log(i);}, 100 * i);
  })(i);
}
*/

/*
function let_test(input: boolean) {
  let a = 100;

  if (input) {
    let b = a + 1;
    return b;
  }

  return b;
}

console.log("let_test");
console.log(let_test(true));
console.log(let_test(false));
*/

/*
function foo() {
  return a;
}
console.log(foo());
let a;
*/

for (let i =0; i < 10; i++) {
  setTimeout(function() {console.log(i);}, 100 * i);
}
