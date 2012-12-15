# make sure bind is defineds
Function::bind ||= (oThis)->  # ref: https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Function/bind
  aArgs = Array::slice.call(arguments, 1)
  fToBind = @
  fNOP = ()->
  fBound = ()->
    fToBind.apply( ( if(oThis && @ instanceof fNOP) then @ else oThis), (aArgs.concat (Array::slice.call arguments) ) )
 
  fNOP.prototype = @prototype
  fBound.prototype = new fNOP()
  fBound


class Mixin

  ###
  #   @@mixinTo
  #   Inject the class and instance (methods and attributes) of this mixin into the target klazz
  ###
  @mixinTo: (klazz, config=null)->

    # extend klazz with mixins that were included
    @extendClass klazz,   @includedAddTheseToClass      # extend the klazz with class methods and static attributes
    @extendInstance klazz::, @includedAddTheseToInstance   # extend the klazz.prototpe with instance methods and instance

    # extend klazz with this mixin
    @extend klazz,   @addTheseToClass      # extend the klazz with class methods and static attributes
    @extend klazz::, @addTheseToInstance   # extend the klazz.prototpe with instance methods and instance attributes

    # make the configs available to the class
    klazz.mixinConfig ||= {}
    @extend klazz.mixinConfig, config if config?  

  ###
  #   @@include
  #   Allows a mixin to include other mixins
  ###
  @include: (OtherMixin)->
    @includedAddTheseToClass ||= {}
    @includedAddTheseToInstance ||= {}
    (@extend @includedAddTheseToClass, OtherMixin.addTheseToClass) if OtherMixin.addTheseToClass?
    (@extend @includedAddTheseToInstance, OtherMixin.addTheseToInstance) if OtherMixin.addTheseToInstance?

  # add unbound functions to the class
  @extendClass: (targetClass, mixin)-> @extend targetClass, mixin

  # bind functions to the objects
  @extendInstance: (targetPrototype, mixin)-> @extend targetPrototype, mixin, true

  @extend: (target, mixin, bindToTarget=false)->
    for key, value of mixin
      boundValue = if bindToTarget && 'function' is typeof value then (value.bind target) else value
      target[key] = boundValue

module.exports = Mixin