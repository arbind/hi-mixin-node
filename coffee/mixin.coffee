class Mixin

  @mixinTo: (klazz)->
    @extend klazz,   @addTheseToClass      # extend the klazz with class methods and static attributes to 
    @extend klazz::, @addTheseToInstance   # extend the klazz.prototpe with instance methods and instance attributes

  @extend: (target, mixin)-> target[key] = value for key, value of mixin

module.exports = Mixin