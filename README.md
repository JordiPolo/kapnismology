# Kapnismology

Kapnismology 'the study of smoke', is a gem which contains an engine to easily create smoke tests.

## Installation

Kapnismology only supports Rails.
In the Gemfile write:
```
gem 'kapnismology', '~> 0.1'
```

In your config/routes write:

```
  mount Kapnismology::Engine, at: "/smoke_test"
```

## Usage

Access the path '/smoke_test' to see the results of the smoke_test


## Adding more smoke tests

Create a class like this:
```
class MySmokeTest < Kapnismology::SmokeTest

  def self.name
    'my_test'
  end

  def result
    "BOOO"
  end
end
```

The class must:
- Inherit from `Kapnismology::SmokeTest`
- Have a method `self.name` returning a string
- Have an instance method `result` returning a Kapnismology::Result object

Any class created this way will be called and its result will be added to a resulting hash.
In this case the result of this class would be added to the result as:
```
{'my_test' => 'BOOO'}
```

## TODO

- rspecs
- Automount routes
- Hypermedia output
