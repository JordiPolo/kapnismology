# Kapnismology

Kapnismology 'the study of smoke', is a gem which contains an engine to easily create smoke tests.

## Installation

Kapnismology only supports Rails.
In the Gemfile write:
```
gem 'kapnismology', '~> 0.2'
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

  def result
    Kapnismology::Result.new(true, {connection: 'good'}, "Connected!")
  end
end
```

The class must:
- Inherit from `Kapnismology::SmokeTest`
- Have an instance method `result` returning a Kapnismology::Result object

Any class created this way will be called and its result will be added to a resulting hash.
In this case the result of this class would be added to the result as:
```
{'MySmokeTest': { passed: true, data: { connection: 'good' }, message: 'Connected!' }}
```

If you want to change the name of the test, define self.name in your
smoke test class.

## TODO

- Automount routes
- Hypermedia output
