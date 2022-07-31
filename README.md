# Hanami::Extensions

This is a [hanami](https://hanamirb.org/) plugin that adds some useful commands to your hanami project.

## Installation

Add this line to your application's Gemfile:

```ruby
group :plugins do
  gem "hanami-extensions", github: "sashimi343/hanami-extensions"
end
```

And then execute `bundle install` command.

## Usage

### Generator commands

Add the following subcommands to `hanami generate` command.

* Generate an interactor class: `hanami generate interactor`
* Generate a validation class: `hanami generate validator`

Example:

Run the following command:

```bash
$ hanami generate interactor add_book
      create  /path/to/your_project/lib/your_project/interactors/add_book_interactor.rb
      create  /path/to/your_project/spec/your_project/interactors/add_book_interactor_spec.rb
```

to generate these files:

lib/your_project/interactors/add_book_interactor.rb

```ruby
require "hanami/interactor"

class AddBookInteractor
  include Hanami::Interactor
  
  def initialize()
    # set up the object
  end
  
  def call(params)
    # get it done
  end
end
```

spec/your_project/interactors/add_book_interactor_spec.rb

```ruby
require_relative "../../spec_helper.rb"

RSpec.describe AddBookInteractor, type: :interactor do
  # place your tests here
end
```

For more usage, please refer to the help of each command.

### DB seeder

Load the seed data into your database.

1. Run `hanami db seed --init` command to prepare these seeder files.

* db/seed.rb: Ruby script file to be called when you run `hanami db seed` command.
* db/fixtures: Directory to store CSV files with seed data.

2. Write your seed data registration code to `db/seed.rb`
A utility class for initial data registration (`Hanami::Extensions::Seeder`) is available.

Example:

db/seed.rb

```ruby
require "hanami/extensions"
require "hanami/environment"

Hanami::Environment.new.require_project_environment
Hanami::Components.resolve("all")
seeder = Hanami::Extensions::Seeder.new

# Add all users in db/fixtures/users.csv to `users` table (delete all users before inserting)
seeder.truncate_insert(UserRepository.new, "users.csv")

# Add all books in db/fixtures/books.csv to `books` table (if `books` table is not empty, skip prpcessing)
seeder.insert_once(BookRepository.new, "books.csv")

# You can write common Hanami code as well
BookshelfRepository.new.create(name: "My bookshelf", owner: "John Doe")
```

3. Run `hanami db seed` command to execute `db/seed.rb` and load seed data.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sashimi343/hanami-extensions.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
