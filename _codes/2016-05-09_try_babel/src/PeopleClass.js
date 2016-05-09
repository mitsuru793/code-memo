export default class People {
  constructor(name, age, from) {
    this.name = name;
    this.age  = age;
    this.from = from;
  }
  hello(toName) {
    return `Hello, ${toName}.`;
  }
  introduce() {
    return `I'm ${this.name}, ${this.age} and from ${this.from}`;
  }
}
