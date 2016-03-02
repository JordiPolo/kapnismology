# Kapnismology

Kapnismology 'the study of smoke', is a gem which contains an engine to easily create smoke tests.

## Installation

Kapnismology only supports Rails.
In the Gemfile write:
```
gem 'kapnismology', '~> 1.2'
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

## Loading tests

Kapnismology will find any class which inherits from `Kapnismology::SmokeTest` in memory.
Kapnismology will require all the files inside `lib/smoke_test`.
If for any reason you want to have your test in any other location, then you will need to make sure they are properly required.

## Naming

If you want to change the name of the test, define `self.name` in your
smoke test class.

## Not runnable tests

If your test find a situation when it does not make sense, then you can return a `Kapnismology::UnTestableResult` instead of a `Kapnismology::Result`. Like:
```
if (File.exist?('that file'))
  Result.new(....)
else
  UnTestableResult.new
end
```

UnTestableResult do not need any parameter.

## Tagging and running tags

All smoke tests are tagged by default with 'deployment' and 'runtime'.
If you want to tag your test with any one of the above or any other tag, just overwrite the `self.categories` method in your smoke test class.
The following example creates a smoke test tagged with the tags 'slow' and 'integration'.

```Ruby
class ExpensiveTest < Kapnismology::SmokeTest
  def result
  end
  def self.categories
    ['slow', 'integration']
  end
end
```

When you call the URL, all smoke tests marked with 'runtime' will be run. As by default all smoke test have the tags 'deployment' and 'runtime' they will all be run.

The above smoke test as it has not the 'runtime' category, it will not be run. To run it you should call your service like this:
```
 wget http://myservice.com/smoke_test?tags=integration_
```

It will run all your integration tests. You can run it together with your runtime tests also:
```
 wget http://myservice.com/smoke_test?tags=integration,runtime
```


## Skipping tests

If you want to skip some smoke test when you call the URL then you can add the 'skip' query parameter to the URL indicating the tests you want to skip.
For instance:
```
 wget http://myservice.com/smoke_test?skip=ToNotBeCalled,NeitherCallThis_
```



## TODO

- Automount routes
- Hypermedia output
