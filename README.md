# Mixin

## Makes it easy to define mixins that can be added to your classes

## Status: Complete

## Installation

    npm install hi-mixin

## Usage

### To define a mixin:
    class ModelBase extends Mixin
      @addTheseToClass: # this (@) refers to the class
        pi: 3.14

      @addTheseToInstance:
        atts: {}
        legs: 4
        get: (field)-> @atts[field]
        set: (field, val)-> @atts[field] = val
    global.ModelBase = ModelBase # optional

### define a mixin that includes another mixin


### To define a mixin that includes another mixin:
    class ORM extends Mixin
      @include ModelBase    

      @addTheseToClass: # this (@) refers to the class
        storage: {}
        count: ()-> @findAll().length
        find: (id)-> @storage[id]
        findAll: ()-> val for own key, val of @storage    

    global.ORM = ORM


### To extend a class with a mixin:
    global.Animal = class Animal
      ORM.mixinTo @

      # can now use get and set methods that were mixed in from ModelBase
      constructor: (@id)->
      type: ()-> @get('type')
      name: ()-> @get('name')             
      setName: (n)-> @set('name', n)

### To use your class:
    lion = new Animal('cat')
    lion.setName('meowie')
    lion.save()
    console.log Animal.count()
    lion.destroy()

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
