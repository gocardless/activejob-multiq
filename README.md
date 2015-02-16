# ActiveJob::Multiq

Use different queue adapters for different jobs.

## Installation

```ruby
# Gemfile
gem 'activejob-multiq'
```

```bash
bundle install
```

## Usage

```ruby
ActiveJob::Base.queue_adapter = :que

# Something important to enqueue with Que
class ChargeCard < ActiveJob::Base
  queue_as :money_things

  def perform(card, amount)
    card.charge(amount)
  end
end

# Something unimportant, to enqueue with Sucker Punch, unless we're in the test
# environment (in which case you'll probably want to use :test or :inline for
# everything)
class RecordAnalytics < ActiveJob::Base
  include ActiveJob::Multiq

  queue_as :noone_cares
  queue_with :sucker_punch, unless: -> { Rails.env.test? }

  def perform(event)
    AnalyticsService.record(event)
  end
end
```

## Contributing

1. Fork it ( https://github.com/gocardless/activejob-multiq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
