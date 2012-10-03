# Phaxio

A Ruby gem for interacting with the [Phaxio API]( https://www.phaxio.com/docs ).



## Installation

Add this line to your application's Gemfile:

    gem 'phaxio'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phaxio

## Usage

Configure a client with an api_key and api_secret:

    @client = Phaxio.client.config do |config|
      config.api_key = 10987654321
      config.api_secret = 12345678910
    end

Send a fax:

    @client.send_fax(to: "0123456789", filename: "test.pdf")

### Currently Supported API Calls

* send_fax
* test_receive
* get_fax_status
* cancel_fax
* get_account_status

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
