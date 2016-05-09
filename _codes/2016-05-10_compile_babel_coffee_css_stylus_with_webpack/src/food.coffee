module.exports = class Food
  constructor: (@name) ->
  sell: (price) ->
    @name + " is $#{price}."
