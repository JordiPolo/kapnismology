# Kapnismology

Kapnismology 'the study of smoke', is a gem containing a Rails engine to easily create smoke tests.

## Installation

In the Gemfile write:
```ruby
gem 'kapnismology', '~> 1.7'
```

In your config/routes write:

```ruby
  Kapnismology::Routes.insert!('/smoke_test')
```

## Usage

Access the path '/smoke_test' to see the results of the smoke_test

## Smoke test output format

The output of the /smoke_test path is a Hypermedia document.

Sample:

```ruby
{
  "_links": {
    "self": "https://www.example.org/smoke_test?tags=runtime",
    "profile": "http://tbd.mdsol.com"
  },
  "passed": false,
  "count": 2,
  "trace_id": "d93abb9f-e0a2-467b-902f-b78069167e8f",
  "codebase_revision": "7beb617",
  "items": [
    {
      "name": "database_smoke_test",
      "passed": true,
      "message": "The database is connected and responding correctly.",
      "data": {
          "database_name": "Polybus"
      }
    },
    {
      "name": "api_smoke_test",
      "passed": false,
      "message": "Api failed to respond correctly.",
      "data": {
         "exception": "name of exception class (StandardError, NoMethodError)",
         "message": "exception message",
         "stack": ["array of strings", "containing the backtrace","one string per backtrace entry"]
      }
    }
  ]
}
```

## Adding more smoke tests

Create a class like this:
```ruby
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
```ruby
{ name: 'my_smoke_test', passed: true, data: { connection: 'good' }, message: 'Connected!' }
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
{ name: 'database smoke test', passed: true, data: { connection: 'good' }, message: 'Connected!' }

```

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

## Timing out

Smoke tests will by default time out after 10 seconds. If you need to change this value overwrite the `timeout` method your smoke test class and return a new number (seconds). Returning `0` will prevent the test from timing out.

```Ruby
class SuperSlowTest < Kapnismology::SmokeTest
  def result
  end
  def self.timeout
    30
  end
end
```


## Skipping tests

If you want to skip some smoke test when you call the URL then you can add the 'skip' query parameter to the URL indicating the tests you want to skip.
For instance:
```
 wget http://myservice.com/smoke_test?skip=ToNotBeCalled,NeitherCallThis
```

## Recommended coding style

Hopefully Kapnismology is flexible enough so you can code your smoke test as you prefer, our recommended style is this:

```ruby
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
```ruby
  RSpec.describe DatabaseSmokeTest do
    let(:result) { Kapnismology::SpecHelper.result_for(described_class.new) }
  ...
```

`result` will be processed so you do not need to deal with the internals of Kapnismology but just check the properties of a Result object

## TODO

- Automount routes
- Hypermedia output
