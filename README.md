# Sidekiq::Control

This gem adds a new tab to Sidekiq to allow starting jobs from the web UI (usually found at `/web/admin/sidekiq/control`)

![image](https://user-images.githubusercontent.com/4623792/61005742-c0d11480-a336-11e9-8fbc-6623f246b599.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-control'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-control

## Usage

Including the gem automatically adds the functionality, no further configuration is necessary!

To include in dev/staging environment specify in your Gemfile

```ruby
group :staging, :development do
  gem 'sidekiq-control', github: 'rvshare/sidekiq-control'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rvshare/sidekiq-control. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sidekiq::Control project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rvshare/sidekiq-control/blob/master/CODE_OF_CONDUCT.md).
