require('style!css!../styles/style');
require('style!css!stylus!../styles/style.styl');

var Person = require('./person'),
    Food   = require('coffee!./food'),
    Car    = require('babel!./car.js').default;

var mike  = new Person('Mike', 18),
    rice  = new Food('Rice'),
    lapin = new Car('Lapin');

console.log(mike.hello());
console.log(rice.sell(80));
console.log(lapin.move(800));
