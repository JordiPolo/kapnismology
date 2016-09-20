# 2.2.1
* Expose the `status` and `render` methods in SmokeTestResponse, so clients can call them directly

# 2.2.0
* Only load Kapnismology engine when Rails is defined
* Support running unit tests without Rails with `NO_RAILS=1 bundle exec rspec`

# 2.1.0
* Output has codebase revision information

# 2.0.3
* Coloring output only on interactive terminals

# 2.0.2
* Make sure the internal @all\_result\_messages array is initialized

# 2.0.1
* Raise ArgumentError when data is not a hash

# 2.0
* Changed the output of the /smoke_test path to support new format
* Removed InfoResult class

# 1.12
* Added timeout functionality. Now smoke tests timeout after 10s by default.
* Rescue exceptions inheriting from Exception to rescue network errors

# 1.11
* Added a class NotApplicableResult for the cases when we really really do not want to show a result in the output

# 1.10
* Added a class InfoResult to substitute NullResult (which is deprecated now)

# 1.9
* NullResult now appears in the output.
* SmokeTestFailed accepts an exception as parameter

# 1.8.2
* Allow to see message, data and extra_messages to make for painless testing

# 1.8.1
* Allow to raise SmokeTestFailed from outside smoketest classes

# 1.8.0
* Added SpecHelper class to make testing of results easier.
* Added parameters to rake task helper so rake tasks can use tags.

# 1.7.0
* Added puts_to_result method to allow context information in checks
* Raising SmokeTestFailed will make a test to return proper failed information
* Returning a Success object will pass the test

# 1.6.0
* Improved terminal output for rake tasks
* Solved bug where smoketest class did not require all its dependencies

# 1.5.0
* Result classes can be used without the Kapnismology module name

# 1.4.0
* Redo untestable result functionality and rename it to NullResult

# 1.3.0
* Add UnTestableResult as a possible result so tests can skip situations

# 1.2.0
* Loads files in 'lib/smoke_test' if available. Do not force eager loading.
* Allow usage with Rails 5

# 1.1.0
* Allows to provide a "tags" parameter to the url to only run smoke tests tagged with certain tags.
* Allows to provide a "skip" parameted to the url to skip certain smoke tests

# 1.0.0
* Output uses "data" to indicate data, the test name is the key of the hash.
* Order of parameters in the Result API has changed to make more sense.
* Classes do not need to specify their name. They still can but it is optional

# 0.1.2
* Add tests for rails 3.2, 4.0, 4.1, 4.2
* Relax dependency to Rails 3.2+

# 0.1.1
* Add evaluation_collection to the repo

# 0.1.0
* Add failure state to the controller
* Delete nil results from the output
