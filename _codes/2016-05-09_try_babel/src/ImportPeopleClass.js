import People from './PeopleClass'

var person = new People('Bob', 19, 'Australia');
console.log(person.name);
console.log(person.hello('Mike'));
console.log(person.introduce());

class Japanese extends People {
  constructor(name, age) {
    super(name, age, 'Japan');
  }
}

var taro = new Japanese('Taro', 18);
console.log(taro.introduce());
