# Phaxio

A Ruby gem for interacting with the [Phaxio API]( https://www.phaxio.com/docs ).

**Note: This gem only runs on Ruby version 1.9.+**

## Installation

Add this line to your application's Gemfile:

    gem 'phaxio'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phaxio

## Usage

Configure Phaxio with your api_key and api_secret:

    Phaxio.config do |config|
      config.api_key = "10987654321"
      config.api_secret = "12345678910"
    end

To send a fax:

    Phaxio.send_fax(to: "0123456789", filename: "test.pdf")

### Currently Supported API Calls

* send_fax - `Phaxio.send_fax(to: "0123456789", filename: "test.pdf")`
* test_receive - `Phaxio.test_receive(filename: "test_file.pdf")`
* provision_number - `Phaxio.provision_number(area_code: 802)`
* release_number - `Phaxio.release_number(number: "8021112222")`
* list_numbers - `Phaxio.list_numbers(area_code: 802)`
* get_fax_status - `Phaxio.get_fax_status(id: "123456")`
* cancel_fax - `Phaxio.cancel_fax(id: "123456")`
* get_account_status - `Phaxio.get_account_status`

### Example

    require 'phaxio'

    Phaxio.config do |config|
      config.api_key = "your_key"
      config.api_secret = "your_secret"
    end

    @fax = Phaxio.send_fax(to: '15555555555', string_data: "hello world")
    Phaxio.get_fax_status(id: @fax["faxId"])

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
