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
  seasons: [{ ... season params ... }, {...}, ...]
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

## Validations, and coercions

No. Entity assumes that given data already validated and coerced.

## DSL

#### property

_TODO_

#### property?

_TODO_

#### timestamps

It is sugar, that expanded to:
```ruby
property :created_at, **opts
property :updated_at, **opts
```

#### object

_TODO_

#### has_one

Just alias for `object`

#### collection

_TODO_

#### has_many

Just alias for `collection`

#### belongs_to

_TODO_

## Instance methods

_TODO_
