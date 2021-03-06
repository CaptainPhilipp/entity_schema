# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.1.7]
### Added
+ `map_to:` option can receive String or Symbol with class name, that will be used for `#const_get` in runtime, after schema building
It needed for prevent constant cross-requirements lock in Ruby: when file `foo.rb` contains class `Foo`, that depends on class `Bar` from file `bar.rb`, and `Bar` depends on `Foo`.

## [0.1.4]
### Improved
+ unknown options calling with `:[]`, `:[]=` now constrainted without additional check `raise if`

### Refactored
+ mechanism of fields building: Builder separated to Contract and Specification

## [0.1.2]
### Added
+ added `.object serializer:` and `mapper:` options
+ options `.object serializer:` and `mapper:` can receive `Symbol`, that will be substituted
  to defined by user _class-level methods_

### Refactored
+ serialization of objects
+ mapping of objects
+ interface of Schema extending from parent schema
+ "unknown field" checking (now, without additional 'if')

## [0.1.1]
### Added (development-only)
+ SimpleCov
+ CodeCov

## [0.1.0]
### Added
+ All base functionality with main specs (141 example)
+ .property
+ .property?
+ .object
+ .collection
+ .has_one
+ .has_many
+ .belongs_to
+ Inheritable
