module.exports = Person = function(name, age) {
  this.name = name;
  this.age = age;
};
Person.prototype.hello = function() {
  return 'Hello, my name is ' + this.name + ', I\'m ' + this.age + ' years old';
};
