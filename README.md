# GabApi

A Ruby client for the [Gab](https://gab.com) API.

## Installation

```ruby
gem 'gab_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gab_api

## Usage

The official [Gab API](https://developers.gab.com/) uses the OAuth2 protocol for authentication which is implemented in a separate Ruby gem called [omniauth-gab](https://github.com/midwire/omniauth-gab).

Install that gem and use it in your Ruby code:

```ruby
access_token = `the token you get back from the omniauth-gab gem after authenticating a user`
GabApi::Client.access_token = access_token
user = GabApi::User.me
#=> #<GabApi::User:0x00007faee70dc8f0
# ...
# :follower_count=>833,
# :following_count=>593,
# :post_count=>634,
# ...
user.username
#=> IamAGabUser
user.score
#=> 23920
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/midwire/gab_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GabApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/midwire/gab_api/blob/master/CODE_OF_CONDUCT.md).
