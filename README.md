[![Build Status](https://secure.travis-ci.org/joakimk/deployer.png)](http://travis-ci.org/joakimk/deployer)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/joakimk/deployer)

## Work in progress

This will be an app to manage deploys. I plan to import some of the internal deployment tools from [barsoom](http://barsoom.se) into this app.

## About the code

I'm trying to find a good adaptation of [The Clean Architecture](http://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html) for larger rails apps, so I'm using this as a playground. Because of this, there might be things in this app that are architectural overkill for such a small app.

## Directory structure

* Models: [app/models](https://github.com/joakimk/deployer/tree/master/app/models)
* Use cases (actions you can take with the app): [app/use_cases](https://github.com/joakimk/deployer/tree/master/app/use_cases)
* Persistence
  - Tested with [shared examples](https://github.com/joakimk/deployer/blob/master/spec/support/shared_examples/build_mapper.rb)
  - Memory storage: [app/repositories/memory](https://github.com/joakimk/deployer/tree/master/app/repositories/memory)
  - ActiveRecord storage: [app/repositories/ar](https://github.com/joakimk/deployer/tree/master/app/repositories/ar)
  - Extracted base code: [minimapper](https://github.com/joakimk/minimapper)
* Testing
  - Unit tests (does not load rails and each test is about 1ms): [unit/](https://github.com/joakimk/deployer/blob/master/unit)
  - Integrated tests (everything else): [spec/](https://github.com/joakimk/deployer/blob/master/spec)

# Architecture

    # Rails ##          # The ruby app #########################
    Controller -------> UseCase -> Model -> Repository(::Memory)
    Mailer                 |                   |
    BG job                 |                   |
                           |                   |
    View <- Presenter <----|                Repository::AR
    # Rails #########                       # Rails ######
            ^^^^^^^^^
            Note: Presenters and code in lib/ can usually be made
                  independent of rails too.

## Fast tests

With this setup you can test [validations](https://github.com/joakimk/deployer/blob/master/unit/models/build_spec.rb) and [persistence](https://github.com/joakimk/deployer/blob/master/unit/use_cases/update_build_status_spec.rb) like you usually do, and still have very fast tests.

    Finished in 0.67609 seconds
    1000 examples, 0 failures

## Benefits of in-memory models

I've found having an in-memory store means I can introduce new models and rename model attributes without having to write a migration right away. I can focus on the design and naming first.

## Problems

Having two persistance adapters means more work. It's a tradeoff. In larger applications it could be a good thing. You can test the code without going out to a database where fully isolated testing isn't possible. It makes it harder for persistance details to leak into the system (SQL in controllers, etc).

Moving persistance out of the models makes it more complex to persist them. Although they are more focused.

## Running the tests

You need postgres installed.

    script/bootstrap

    rake              # all tests
    rake spec:unit    # unit tests
    rake spec         # integrated tests in-memory
    rake spec:db      # integrated tests with a database
    rake spec:db_only # only database adapter tests
