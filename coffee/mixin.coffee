class Mixin

  ###
  #   @@mixinTo
  #   Inject the class and instance (methods and attributes) of this mixin into the target klazz
  ###
  @mixinTo: (klazz)->
    # extend klazz with included mixins (if any)
    @extend klazz,   @includedAddTheseToClass      # extend the klazz with class methods and static attributes
    @extend klazz::, @includedAddTheseToInstance   # extend the klazz.prototpe with instance methods and instance

    # extend klazz with this mixin
    @extend klazz,   @addTheseToClass      # extend the klazz with class methods and static attributes
    @extend klazz::, @addTheseToInstance   # extend the klazz.prototpe with instance methods and instance attributes

  ###
  #   @@include
  #   Allows a mixin to include other mixins
  ###
  @include: (OtherMixin)->
    @includedAddTheseToClass ||= {}
    @includedAddTheseToInstance ||= {}
    (@extend @includedAddTheseToClass, OtherMixin.addTheseToClass) if OtherMixin.addTheseToClass?
    (@extend @includedAddTheseToInstance, OtherMixin.addTheseToInstance) if OtherMixin.addTheseToInstance?

  @extend: (target, mixin)-> target[key] = value for key, value of mixin

module.exports = Mixin