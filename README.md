# EntitySchema
class-level DSL for mapping Hash with object-like structure to Object (as Entity or Value Object), and then return it into Hash

## Performance

Focused on minimal, lazy interaction with raw Hash:
it means, that if you execute something like this:
```
hash = { foo: 'FOO', bar: 'BAR' }
FooBarEntity.new(hash).to_h
```
It will only `#slice` hash, and returns it innocent

## Validations, and coercions

No. Entity assumes that given data already validated and coerced.

## Associations

Entity allow you to manage associated objects and collections to Objects you want

```
class Entity
  extend EntitySchema

  object     :obj,  map_to: OpenStruct
  has_one    :one,  map_to: MyObject, map_method: :newww
  has_many   :many, map_to: OpenStruct
  belongs_to :belonged, { belonged_uid: :id }, map_to: OpenStruct
end

class MyObject
  def self.newww(h)
    new(h)
  end

  def initialize(id:)
    @id = id
  end
end

entity = Entity.new(obj: { foo: 'foo' },
                    one: { bar: 'bar' },
                    many: [{ id: 1 }, { id: 2 }],
                    belong: { id: 3 })

entity.obj      # => <OpenStruct @foo: 'foo'>
entity.one      # => <MyObject @bar: 'bar'>
entity.many     # => [<OpenStruct @id: 1>, <OpenStruct @id: 2>]
entity.belonged # => <OpenStruct @id: 3>

entity.obj.foo = 'FOO'
entity.one.bar = 'BAR'

entity.given?(:belonged) # => true
entity.belonged          # => <OpenStruct @id: 3>
entity.belonged_uid = nil
entity.belonged          # => nil
entity.given?(:belonged) # => false

entity.to_h # => { obj: { foo: 'FOO' }, one: { bar: 'BAR' }, many: [{ id: 1 }, { id: 2 }] }
```
