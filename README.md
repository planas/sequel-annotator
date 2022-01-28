# Sequel::Annotator

Just an utility class to generate and inject Sequel model annotations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sequel-annotator'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sequel-annotator

## Usage

```ruby
# Load your models
Dir["#{model_dir}/*.rb"].each { |m| require m }

# Define a map of paths
paths = Hash[
  'models'         => proc { |m| "#{m.to_s.demodulize.underscore}.rb" },
  'spec/models'    => proc { |m| "#{m.to_s.demodulize.underscore}_spec.rb" },
  'spec/factories' => proc { |m| "#{m.to_s.demodulize.pluralize.underscore}.rb" }
]

Sequel::Model.subclasses.each do |model|
  Sequel::Annotator.new(model, paths).annotate
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/planas/sequel-annotator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/planas/sequel-annotator/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sequel::Annotator project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sequel-annotator/blob/master/CODE_OF_CONDUCT.md).
