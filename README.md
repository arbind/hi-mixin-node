# Mixin

### Make it easy to define mixins that can be added to your classes

## Installation

    npm install hi-mixin

## Usage

How to add a mixin called ORM to class Animal and then use it:

    class Animal
      ORM.mixinTo @

    lion = new Animal('cat')
    lion.setName('meowie')
    lion.save()

## Development

When defining a mixin (like ORM), you can:

1. Define static methods and attributes to add to the class itself (like find())
2. Define instance methods and attributes (like save())
3. Build off of another mixin by including it

For example:

    global.Mixin = require 'hi-mixin'

    class ModelBase extends Mixin
      @addTheseToInstance:
        atts: {}
        get: (field)-> @atts[field]
        set: (field, val)-> @atts[field] = val

    class ORM extends Mixin
      @include ModelBase    
    
      @addTheseToClass: # @ refers to the class
        storage: {}
        count: ()-> @findAll().length
        find: (id)-> @storage[id]
        findAll: ()-> val for own key, val of @storage    
    
      @addTheseToInstance:  # @ refers to the instance
        id: null
        save: ()-> global[@constructor.name].storage[@id] = @
        destroy:()-> delete global[@constructor.name].storage[@id]

## Working Example Code
To run [example-1.coffee](https://github.com/carbonfive/hi-mixin-node/blob/master/examples/example-1.coffee):

    coffee  ./examples/example-1.coffee

## Inspiration
This package enhances the example from [The Little Book on CoffeeScript](http://arcturo.github.com/library/coffeescript/03_classes.html) to be more usable:

1. A class that uses a mixin doesn't need to extend anything
2. A mixin can compose other mixins to make it easier and cleaner to add functionality to class
3. A mixin can be configured when adding it to a class

## Get Inspired and Contribute!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Update the specs and source files (./spec and ./coffee)
4. Build the project (coffee --compile  -o ./lib ./coffee)
5. Run the tests (npm test)
6. Commit your changes (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request

## Test

    npm test

## Build

    coffee --compile  -o ./lib ./coffee
