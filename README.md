# EntitySchema
[![Gem Version](https://badge.fury.io/rb/entity_schema.svg)](https://badge.fury.io/rb/entity_schema)
[![Build Status](https://travis-ci.org/CaptainPhilipp/entity_schema.svg?branch=master)](https://travis-ci.org/CaptainPhilipp/entity_schema)
[![codecov](https://codecov.io/gh/CaptainPhilipp/entity_schema/branch/master/graph/badge.svg)](https://codecov.io/gh/CaptainPhilipp/entity_schema)

Class-level DSL for mapping Hash with object-like structure to Object (as Entity), and then return it into Hash.

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

  belongs_to :color,   map_to: Color, pk: :color_uid, fk: :uid
  has_many   :seasons, map_to: Season
end
```

## Motivation

When you work with plain hashes (`Sequel`, `ROM`, `json`/`xml`-sourced data, etc), and want to describe some ___entities___ or ___value objects___ (DDD patterns).

Ok, if `ROM`, why not `ROM::Struct`?

If you using `ROM` with it's `ROM::Struct`, you may encounter some things that do not satisfy some needs: private attributes, value object mapping, may be something other.

## Installation

in Gemfile add
```
gem 'entity_schema'
```

## Usage

### Create entity from hash:
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
product.to_h # =>
  {
    id: 42,
    title: 'Perfect product',
    enabled: true,
    is_new: false,
    is_sale: false,
    is_bestseller: true,
    created_at: '2018-08-16 20:17:55 UTC',
    updated_at: '2018-08-16 20:17:55 UTC',
    size: { ... size params ... },
    color_uid: nil,
    seasons: [{ ... seasons params ... }, {...}, ...]
  }
```

## Validations, and coercions

No. Entity assumes that given data already validated and coerced.

## DSL

### `property`

_TODO: description_

### `property?`

_TODO: description_

### `timestamps`

Just sugar, same as:
```ruby
property :created_at, private: :setter, **opts
property :updated_at, private: :setter, **opts
```

### `object`

_TODO: description_

### `collection`

_TODO: description_

### `has_one`

Just alias for `object`

### `has_many`

Just alias for `collection`

### `belongs_to`

_TODO: description_

## Instance methods

_TODO: description_
