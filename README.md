# EntitySchema
Class-level DSL for mapping Hash with object-like structure to Object (as Entity), and then return it into Hash.

Focused on quick, minimal, lazy interaction with source Hash.

#### Describe entity structure:
```ruby
class Product
  property  :id
  property  :title
  property? :enabled
  property? :new,        key: :is_new
  property? :sale,       key: :is_sale
  property? :bestseller, key: :is_bestseller
  timestamps

  object :size, map_to: Values::Size

  belongs_to :color, { color_uid: :uid }, map_to: Color
  has_many   :seasons,                    map_to: Season
end
```

#### Create entity from hash:
```ruby
raw_hash = {
  id: 42,
  title: 'Perfect product',
  enabled: true,
  is_new: false,
  is_sale: false,
  is_bestseller: true,
  created_at: '2018-08-16 20:17:55 UTC',
  updated_at: '2018-08-16 20:17:55 UTC',
  size: { ... size params ... },
  color_uid: 7,
  seasons: [{ ... seasons params ... }, {...}, ...]
}

product = Product.new(raw_hash)
product.title
product.sale?
product.size            # => <Values::Size ... >
product.seasons         # => [<Season ... >, <Season ... >, ...]

product.color           # => <Color @uid=7 ... >
product.color_uid       # => 7
product.color = nil     # => nil
product.color_uid       # => nil
```

#### Return entity to hash:
```ruby
product.to_h
# => {
# =>   id: 42,
# =>   title: 'Perfect product',
# =>   enabled: true,
# =>   is_new: false,
# =>   is_sale: false,
# =>   is_bestseller: true,
# =>   created_at: '2018-08-16 20:17:55 UTC',
# =>   updated_at: '2018-08-16 20:17:55 UTC',
# =>   size: { ... size params ... },
# =>   color_uid: nil,
# =>   seasons: [{ ... seasons params ... }, {...}, ...]
# => }
```

## Performance

EntitySchema focused on minimal, lazy interaction with raw Hash:
it means, that if you execute something like this:
```ruby
hash = { foo: 'FOO', bar: 'BAR' }
FooBarEntity.new(hash).to_h
```
It will only `#slice` hash, and returns it innocent.

## Validations, and coercions

No. Entity assumes that given data already validated and coerced.

## Associations

Entity allow you to manage associated objects and collections to Objects you want

#### Assume that we have this class:
```ruby
class MyObject
  def self.wrap(h)
    new(h)
  end

  def initialize(id:)
    @id = id
  end
end
```

#### So we can describe Entity:
```ruby
class Entity
  extend EntitySchema

  object     :obj,  map_to: MyObject, map_method: :wrap
  has_one    :one,  map_to: OpenStruct
  has_many   :many, map_to: OpenStruct
  belongs_to :belonged, { belonged_uid: :id }, map_to: OpenStruct
end
```

### And work with it like this:
```ruby
hash = {
  obj:    { foo: 'foo' },
  one:    { bar: 'bar' },
  many:   [{ id: 1 }, { id: 2 }],
  belong: { id: 3 }
}

entity = Entity.new(hash)

entity.obj      # => <MyObject @foo: 'foo'>
entity.one      # => <OpenStruct @bar: 'bar'>
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
