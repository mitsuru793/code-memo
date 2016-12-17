let x: [string, number];
x = ['hello', 10];
// x = [10, 'hello'];

x[0].substr(1);
// x[1].substr(1);

x[3] = 'world';
// x[3].substr(1);

// コンパイルOK 実行エラーになる。
// Cannot read property 'toString' of undefined
// x[5].toString();

// warningだが、実行上は問題ない。
// x[6] = true;
// console.log(x);

enum Color {Red, Green, Blue};
let c: Color = Color.Green;
console.log(Color);
console.log(Color[0]); // Red
console.log(Color.Red); // 0
console.log(c);

let notSure: any = 4;
notSure = "maybe a string instead";
notSure = false;

// コンパイルOK 実行エラーになる。
// notSure.ifItExists();
// notSure.toFixed();

// warningだが、実行上は問題ない。
// let prettySure: Object = 4;
// prettySure.toFixed();

function warnUser(): void {
 console.log("This is my warning message");
 // null/undefinedを明示的に返しても警告はない
 // return undefined;
 // return null;
}
warnUser();

let unusable: void = undefined;
unusable = null;

let someValue: any = "this is a string";
// let someValue: any = true;
let strLength: number = (<string>someValue).length;
//let strLength: number = (someValue).length;
//let strLength: number = someValue.length;

// let num: number = <string>someValue
let num: number = someValue
var var_val = false;
