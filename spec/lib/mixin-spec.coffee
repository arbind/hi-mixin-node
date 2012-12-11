###
#   Create some test mixins
###

global.ModelBase = class ModelBase extends Mixin
  @addTheseToInstance =  # this (@) refers to the instance
    legs: 4
    atts: {}
    get: (field)-> @atts[field]
    set: (field, val)-> @atts[field] = val
global.ORM = class ORM extends Mixin
  @addTheseToClass = # this (@) refers to the class
    storage: {}
    someData: {init:'init'}
    count: ()-> @findAll().length
    find: (id)-> @storage[id]
    findAll: ()-> val for own key, val of @storage

    materialize: (attributes) ->
      obj = @find(attributes.id) if attributes.id?
      obj ||= new @
      obj.set(key, val) for own key, val of attributes
      obj

  @addTheseToInstance:  # this (@) refers to the instance
    id: null
    save: ()-> global[@constructor.name].storage[@id] = @
    destroy:()-> delete global[@constructor.name].storage[@id]

###
#   Create a test class that uses the test mixins
###

global.Animal = class Animal
  ModelBase.mixinTo @
  ORM.mixinTo @

  # can now use get and set methods that were mixed in from ModelBase:
  constructor: (@id)->
  type: ()-> @get('type')
  name: ()-> @get('name')             
  setName: (n)-> @set('name', n)

global.Kangaroo = class Kangaroo extends Animal
  constructor: ()-> super ('kangaroo')
  legs: 2

global.Fish = class Fish extends Animal
  ModelBase.mixinTo @
  constructor: ()-> super ('fish')
  legs: 0

###
#   Spec that tests Mixin
###
describe 'Mixin', ->
  ###
  #   instance variables shared by specs
  ###
  @subject = null

  it 'exists', (done)=> 
    (expect Mixin).to.exist
    done()

  it 'class method can be mixed into a class', (done)=> 
    (expect Animal).itself.to.respondTo('count')
    done()

  it 'class attribute can be mixed into a class', (done)=> 
    (expect Animal.someData).to.exist
    (expect Animal.someData.init).to.equal 'init'
    done()

  it 'instance method can be mixed into a class', (done)=> 
    lion = new Animal('cat')
    (expect Animal).itself.not.to.respondTo('save')
    (expect lion).to.respondTo('save')
    done()

  it 'instance attribute can be mixed into a class', (done)=> 
    lion = new Animal('cat')
    (expect lion.legs).to.equal 4
    done()

  it 'instance attribute mixed into a class can be overriden', (done)=> 
    kang = new Kangaroo()
    (expect kang.legs).to.equal 2
    done()

  it 'instance methods work', (done)=> 
    kang = new Kangaroo()
    kang.setName 'jumpie'
    (expect kang.get('name')).to.equal 'jumpie'
    done()

  it 'class methods work', (done)=> 
    # instantiate some new pets
    lion = new Animal('cat')
    lion.setName('meowie')
    kang = new Kangaroo()
    kang.setName 'jumpie'
    fish = new Fish()
    fish.setName('swimmy')

    (expect Animal.count()).to.equal 0
    (expect Kangaroo.count()).to.equal 0
    (expect Fish.count()).to.equal 0

    # Save the pets
    lion.save()
    (expect Animal.count()).to.equal 1
    kang.save()
    (expect Kangaroo.count()).to.equal 2
    fish.save()
    (expect Fish.count()).to.equal 3
    
    (expect Animal.count()).to.equal 3

    # set the pets free
    lion.destroy()
    (expect Animal.count()).to.equal 2
    kang.destroy()
    (expect Kangaroo.count()).to.equal 1
    fish.destroy()
    (expect Fish.count()).to.equal 0

    (expect Animal.count()).to.equal 0

    done()
