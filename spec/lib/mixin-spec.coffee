###
#   Create some test mixins
###

global.ModelBase = class ModelBase extends Mixin
  @addTheseToClass:
    topClassAtt: {data: 'Top Class Att'}
    topClassMethod: ()-> 'Top Class Method'

  @addTheseToInstance:  # this (@) refers to the instance
    topInstanceAtt: {data:'Top Instance Att'}
    topInstanceMethod: ()-> 'Top Instance Method'
    legs: 4
    atts: {}
    get: (field)-> @atts[field]
    set: (field, val)-> @atts[field] = val

global.ORM = class ORM extends Mixin
  @include ModelBase

  @addTheseToClass: # this (@) refers to the class
    bottomClassAtt: {data:'Bottom Class Att'}
    bottomClassMethod: ()-> 'Bottom Class Method'
    storage: {}
    count: ()-> @findAll().length
    find: (id)-> @storage[id]
    findAll: ()-> val for own key, val of @storage

    materialize: (attributes) ->
      obj = @find(attributes.id) if attributes.id?
      obj ||= new @
      obj.set(key, val) for own key, val of attributes
      obj

  @addTheseToInstance:  # this (@) refers to the instance
    bottomInstanceAtt: {data: 'Bottom Instance Att'}
    bottomInstanceMethod: ()-> 'Bottom Instance Method'
    id: null
    save: ()-> global[@constructor.name].storage[@id] = @
    destroy:()-> delete global[@constructor.name].storage[@id]

###
#   Create a test class that uses the test mixins
###

global.Animal = class Animal
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
    lion = new Animal('cat')
    (expect lion).to.not.respondTo 'bottomClassMethod'

    (expect Animal).itself.to.respondTo 'bottomClassMethod'
    (expect Animal.bottomClassMethod()).to.equal 'Bottom Class Method'

    done()

  it 'class attribute can be mixed into a class', (done)=> 
    lion = new Animal('cat')
    (expect lion.bottomClassAtt).to.not.exist

    (expect Animal.bottomClassAtt).to.exist
    (expect Animal.bottomClassAtt.data).to.equal 'Bottom Class Att'

    done()

  it 'instance method can be mixed into a class', (done)=> 
    lion = new Animal('cat')
    (expect lion).to.respondTo 'bottomInstanceMethod'
    (expect lion.bottomInstanceMethod()).to.equal 'Bottom Instance Method'

    (expect Animal).itself.not.to.respondTo 'bottomInstanceMethod'
    done()

  it 'instance attribute can be mixed into a class', (done)=> 
    lion = new Animal('cat')
    (expect lion.bottomInstanceAtt).to.exist
    (expect lion.bottomInstanceAtt.data).to.equal 'Bottom Instance Att'
    (expect lion.legs).to.equal 4

    (expect Animal.bottomInstanceAtt).to.not.exist
    done()

  it 'instance attribute mixed into a class can be overriden', (done)=> 
    kang = new Kangaroo()
    (expect kang.legs).to.equal 2
    done()

  it 'can include another mixin', (done)=> 
    lion = new Animal('cat')
    (expect lion).to.not.respondTo 'topClassMethod'
    (expect lion).to.not.respondTo 'bottomClassMethod'

    (expect lion.topClassAtt).to.not.exist
    (expect lion.bottomClassAtt).to.not.exist

    (expect lion).to.respondTo 'topInstanceMethod'
    (expect lion.topInstanceMethod()).to.equal 'Top Instance Method'

    (expect lion).to.respondTo 'bottomInstanceMethod'
    (expect lion.bottomInstanceMethod()).to.equal 'Bottom Instance Method'

    (expect lion.topInstanceAtt).to.exist
    (expect lion.topInstanceAtt.data).to.equal 'Top Instance Att'

    (expect lion.bottomInstanceAtt).to.exist
    (expect lion.bottomInstanceAtt.data).to.equal 'Bottom Instance Att'

    (expect Animal).itself.to.respondTo 'topClassMethod'
    (expect Animal.topClassMethod()).to.equal 'Top Class Method'

    (expect Animal).itself.to.respondTo 'bottomClassMethod'
    (expect Animal.bottomClassMethod()).to.equal 'Bottom Class Method'

    (expect Animal.topClassAtt).to.exist
    (expect Animal.topClassAtt.data).to.equal 'Top Class Att'

    (expect Animal.bottomClassAtt).to.exist
    (expect Animal.bottomClassAtt.data).to.equal 'Bottom Class Att'

    (expect Animal).itself.not.to.respondTo 'topInstanceMethod'
    (expect Animal).itself.not.to.respondTo 'bottomInstanceMethod'

    (expect Animal.topInstanceAtt).to.not.exist
    (expect Animal.bottomInstanceAtt).to.not.exist

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
