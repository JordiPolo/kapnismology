# Kapnismology

Kapnismology 'the study of smoke', is a gem containing a Rails engine to easily create smoke tests.

## Installation

In the Gemfile write:
```
gem 'kapnismology', '~> 1.7'
```

In your config/routes write:

```
  Kapnismology::Routes.insert!('/smoke_test')
```

## Usage

Access the path '/smoke_test' to see the results of the smoke_test


## Adding more smoke tests

Create a class like this:
```
class MySmokeTest < Kapnismology::SmokeTest

  def result
    Success.new({connection: 'good'}, "Connected!")
  end
end
```

The class must:
- Inherit from `Kapnismology::SmokeTest`
- Have an instance method `result` returning a Result or Success object

A test passes if it returns:
`Result.new(true, data, message)` or
`Success.new(data, message)`

A test fails if it returns:
`Result.new(false, data, message)` or
`raise SmokeTestFailed.new(data, message)`


Any class created this way will be called and its result will be merged with other results.
In the example above the result of this class would be added to the results as:
```
{'MySmokeTest': { passed: true, data: { connection: 'good' }, message: 'Connected!' }}
```

## Loading tests

Kapnismology will find any class which inherits from `Kapnismology::SmokeTest` in memory.
Kapnismology will require all the files in your project in the path `lib/smoke_test`.
If for any reason you want to have your test in any other location, then you will need to make sure they are properly required.

## Naming

If you want to change the name tests are reported in the final result, define `self.name` in your smoke test class.

```ruby
class MySmokeTest < Kapnismology::SmokeTest
  def self.name
    'Database smoke test'
  end
  def result
    Success.new({connection: 'good'}, "Connected!")
  end
end
```

Will produce:
```ruby
{'Database smoke test': { passed: true, data: { connection: 'good' }, message: 'Connected!' }}

```

## Not runnable tests

If your check finds a situation when it does not make sense to test, you can return a `InfoResult` instead of a `Result`. Like:
```ruby
if (File.exist?('necessary file'))
  Result.new(....)
else
  InfoResult.new({}, 'There is no need to run this test')
end
```

Be very careful of not returning InfoResult when you should be returning a failing Result.


## Tagging and running tags

All smoke tests are tagged by default with 'deployment' and 'runtime'.
If you want to tag your test with any one of the above or any other tag, just overwrite the `self.tags` method in your smoke test class.
The following example creates a smoke test tagged with the tags 'slow' and 'integration'.

```Ruby
class ExpensiveTest < Kapnismology::SmokeTest
  def result
  end
  def self.tags
    ['slow', 'integration']
  end
end
```

When you call the URL, all smoke tests marked with 'runtime' will be run. As by default all smoke test have the tags 'deployment' and 'runtime' they will all be run.

The above smoke test as it has not the 'runtime' category, it will not be run. To run it you should call your service like this:
```
 wget http://myservice.com/smoke_test?tags=integration
```

It will run all your integration tests. You can run it together with your runtime tests also:
```
 wget http://myservice.com/smoke_test?tags=integration,runtime
```


## Skipping tests

If you want to skip some smoke test when you call the URL then you can add the 'skip' query parameter to the URL indicating the tests you want to skip.
For instance:
```
 wget http://myservice.com/smoke_test?skip=ToNotBeCalled,NeitherCallThis
```

## Recommended coding style

Hopefully Kapnismology is flexible enough so you can code your smoke test as you prefer, our recommended style is this:

```
def result
  user = user_from_remote
  puts_to_result('User successfully retrieved')

  role = role_from_remote(user)
  puts_to_result('Role for the user retrieved')

  if check_permissions(user, role)
    Result.new(true, {user: user, role: role}, "Permissions are properly set")
  else
    Result.new(false, {user: user, role: role}, "Permissions failed")
  end
end

def user_from_remote
  get_user
rescue => e
  raise SmokeTestFailed.new(e, "Error raised when accessing user")
end
 ...
```

Using small methods that raise SmokeTestFailed when failed will help you write an easy to read `result` method.
You can pass your own data to SmokeTestFailed or you can pass an exception which will be properly formatted.


## Testing

There is a Kapnismology::SpecHelper which can be useful when running your tests.
Usage:
```
  RSpec.describe DatabaseSmokeTest do
    let(:result) { Kapnismology::SpecHelper.result_for(described_class.new) }
  ...
```

`result` will be processed so you do not need to deal with the internals of Kapnismology but just check the properties of a Result object

## TODO

- Automount routes
- Hypermedia output
