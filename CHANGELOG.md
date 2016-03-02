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
* Output uses "data" to indicate data, the test name is the key of the
  hash.
* Order of parameters in the Result API has changed to make more sense.
* Classes do not need to specify their name. They still can but it is
  optional

# 0.1.2
* Add tests for rails 3.2, 4.0, 4.1, 4.2
* Relax dependency to Rails 3.2+

# 0.1.1
* Add evaluation_collection to the repo

# 0.1.0
* Add failure state to the controller
* Delete nil results from the output
