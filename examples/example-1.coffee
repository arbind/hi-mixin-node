global.Mixin = require '../index'

class ModelBase extends Mixin
  @addTheseToClass: # this (@) refers to the class
    pi: 3.14

  @addTheseToInstance:
    atts: {}
    legs: 4
    get: (field)-> @atts[field]
    set: (field, val)-> @atts[field] = val

global.ModelBase = ModelBase # optional

class ORM extends Mixin
  @include ModelBase    

  @addTheseToClass: # this (@) refers to the class
    storage: {}
    count: ()-> @findAll().length
    find: (id)-> @storage[id]
    findAll: ()-> val for own key, val of @storage    

  @addTheseToInstance:  # this (@) refers to the instance
    id: null
    save: ()-> global[@constructor.name].storage[@id] = @
    destroy:()-> delete global[@constructor.name].storage[@id]

global.ORM = ORM

global.Animal = class Animal
  ORM.mixinTo @

  # can now use get and set methods that were mixed in from ModelBase
  constructor: (@id)->
  type: ()-> @get('type')
  getName: ()-> @get('name')             
  setName: (n)-> @set('name', n)


console.log 'init:    # animals = ', Animal.count()

tiger = new Animal('cat')
tiger.setName('meowie')
tiger.save()

console.log 'saved:   # animals = ', Animal.count()

l = Animal.find('cat')
console.log 'id:     ', l.id
console.log 'name:   ', l.getName()

tiger.destroy()

console.log 'deleted: # animals = ', Animal.count()

console.log 'pi:     ', Animal.pi
