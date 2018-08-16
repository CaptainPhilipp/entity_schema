# entity_schema
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

No.
Entity assumes that given data already validated and coerced.

Entity allow you to manage associated objects and collections to Objects you want
