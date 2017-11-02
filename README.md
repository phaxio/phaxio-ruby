# Phaxio

[![Build Status](https://travis-ci.org/phaxio/phaxio-ruby.svg?branch=master)](https://travis-ci.org/phaxio/phaxio-ruby)

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

    Phaxio.send_fax(to: "0123456789", filename: File.new("test.pdf"))

### Currently Supported API Calls

**TODO: Add examples**

#### Faxes

* `create` - Create and send a fax
* `list` - List faxes in date range
* `get` - Get fax info
* `cancel` - Cancel a fax
* `resend` - Resend a fax
* `delete` - Delete fax
* `delete_file` - **PENDING** Delete fax file
* `file` - **PENDING** Get fax content file or thumbnail
* `test_receive` - **PENDING** Test receiving a fax
* `supported_countries` - **PENDING** Get a list of supported countries

#### Phone Numbers

* `create` - Provision a phone number
* `list` - List numbers
* `get` - Get number info
* `delete` - Release a number
* `list_available_area_codes` - List area codes available for purchasing numbers

#### PhaxCodes

* `create` - **PENDING** Create PhaxCode
* `get` - **PENDING** Retrieve PhaxCode

#### Account

* `get` - Get account status

### Example

**TODO: Revise for v2**

    require 'phaxio'

    Phaxio.config do |config|
      config.api_key = "your_key"
      config.api_secret = "your_secret"
    end

    @fax = Phaxio.send_fax(to: '15555555555', string_data: "hello world")
    Phaxio.get_fax_status(id: @fax["faxId"])

    # Get a Fax and save it as a PDF
    @pdf = Phaxio.get_fax_file(id: @fax["faxId"], type: "p")
    File.open("received_test.pdf", "w") do |file|
      file << @pdf
    end

## Callback Validation Example with Sinatra

**TODO: Revise for v2**

    require 'sinatra/base'
    require 'phaxio'

    class PhaxioCallbackExample < Sinatra::Base
      Phaxio.config do |config|
        config.api_key = '0123456789'
        config.api_secret = '0123456789'
        config.callback_token = '0123456789'
      end

      post '/phaxio_callback' do
        if Phaxio.valid_callback_signature?(
          request.env['HTTP_X_PHAXIO_SIGNATURE'],
          request.url, callback_params, params[:filename])
          'Success'
        else
          'Invalid callback signature'
        end
      end

      def callback_params
        params.select do |key, _value|
          %w(success is_test direction fax metadata message).include?(key)
        end
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

1. Rewrite README for V2 updates
2. Support old-school configuration (`Phaxio.configure do |config| ...`)
3. Flesh out Records, References, and Collections
4. Handle JSON parsing errors
5. Document that specs for actions which are dependent upon others need to be tested in isolation if
   testing against the API, and that sleeps may be needed to prevent timeouts.
6. Find a better way to generate API responses for tests
7. Implement Fax test_receive, get_fax_file (find_fax_file, retrieve_fax_file), and delete (destroy)
8. Implement PhaxCode create and get (find, retrieve)
9. Implement Callback validate_signature and valid_signature?
