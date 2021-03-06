# Todoable

Todoable is a gem that allows your app to manage lists and items!

This gem is a very simple wrapper that simplifies calls to the Todoable API by Teachable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todoable', git: 'git@github.com:andyywz/todoable.git'
```

And then execute:

    $ bundle


NOTE: As of this README, the gem is not public so you won't be able to install the gem locally via RubyGems.


## Usage

To begin, login to a todoable session by using the following commands.

```ruby
session = Todoable::Session.new(your_username, your_password)

session.authenticate # returns the access token on success
```

When you have successfully logged in, your session token will be stored by the session object.
The session token will expire every 20 minutes. However, do not worry, if your token has expired
when you try to make a request, the session will automatically re-authenticate your user with the
same credentials you provided when you initially logged in.


**Managing Lists**

Here are some of the actions you can take to manage your lists.

```ruby
# returns an array of all the lists belonging to the current user
session.lists

# returns the attributes of the list specified by id
session.get_list(list_id)

# creates a new list, returns the attributes of the created list
session.create_list('list name')

# updates the name of a specific list, returns the updated name
session.update_list_name(list_id, 'new name')

# delete a specific list
session.delete_list(list_id)
```

**Managing Items**

Here are some of the actions you can take to manage your items.

```ruby
# create an item within a specific list, returns the attributes of the created item
session.create_item(list_id, 'item name')

# mark a specific item as complete within a specific list
session.mark_complete(list_id, item_id)

# delete a specific item in a specific list
session.delete_item(list_id, item_id)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version,
update the version number in `version.rb`, and then run `bundle exec rake release`, which will create
a git tag for the version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andyywz/todoable.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Todoable project’s codebases, issue trackers, chat rooms and mailing
lists is expected to follow the
[code of conduct](https://github.com/andyywz/todoable/blob/master/CODE_OF_CONDUCT.md).
