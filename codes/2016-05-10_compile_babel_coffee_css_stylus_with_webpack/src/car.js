export default class Car {
  constructor(name) {
    this.name = name;
  }
  move(meters) {
    return `${this.name} moved ${meters}m.`;
  }
}
