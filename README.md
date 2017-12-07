# 📠 Phaxio

[![Build Status](https://travis-ci.org/phaxio/phaxio-ruby.svg?branch=master)](https://travis-ci.org/phaxio/phaxio-ruby)

A Ruby gem for interacting with the [Phaxio API](https://www.phaxio.com/docs/api/v2).

## Installation

Add to your application's Gemfile:

``` ruby
gem 'phaxio', '~> 2.0.0'
```

And then execute:

``` sh
$ bundle install
```

Or install it yourself as:

``` sh
$ gem install phaxio
```

## Usage

Set up your API Key, API Secret, and, optionally, Callback Token.

``` ruby
require 'phaxio'

Phaxio.api_key = '11111'
Phaxio.api_secret = '22222'
Phaxio.callback_token = '33333'
```

Try sending a fax:

``` ruby
fax_file = File.open 'test.pdf', 'rb'
Phaxio::Fax.create to: '+15558675309', file: fax_file
```

You can include `Phaxio::Resources` to pull in the resource classes for convenience:

``` ruby
include Phaxio::Resources

fax_file = File.open 'test.pdf', 'rb'
Fax.create to: '+15558675309', file: fax_file
```


### Currently Supported API Calls

#### Faxes

##### `Fax.create`

Create and send a fax.

``` ruby
fax_file = File.open 'test.pdf', 'rb'
ref = Fax.create to: '+15558675309', file: fax_file
# => Fax::Reference(id: 1234)
fax = ref.get
# => Fax(id: 1234, num_pages: 1, ...)
```

##### `Fax.list`

List faxes in date range.

``` ruby
start = 2.weeks.ago
stop = 1.week.ago
faxes = Fax.list created_after: start, created_before: stop
# => Phaxio::Resource::Collection([Fax(id: 1234, ...), ...])
faxes.length
# => 5
faxes.map(&:cost).inject(&:+)
# => 35
```

##### `Fax.get`

Get information about a specific fax.

``` ruby
fax = Fax.get 1234
# => Fax(id: 1234, ...)
```

##### `Fax.cancel`

Cancel a fax.

``` ruby
Fax.cancel 1234
# => Fax::Reference(id: 1234)
```

##### `Fax.resend`

Resend a fax.

``` ruby
Fax.resend 1234
# => Fax::Reference(id: 5678)
```

##### `Fax.delete`

Delete a fax. Only test faxes are allowed to be deleted.

``` ruby
Fax.delete 1234
# => true
```

##### `Fax.delete_file`

Delete fax file.

``` ruby
Fax.delete_file 1234
# => true
```

##### `Fax.file`

``` ruby
Fax.file 1234
# => File
```

##### `Fax.test_receive`

Test receiving a fax.

``` ruby
fax_file = File.open 'test.pdf', 'rb'
Fax.test_receive file: fax_file
# => true
```

##### `Fax.supported_countries`

Get a list of supported countries.

``` ruby
Fax.supported_countries
# => Phaxio::Resource::Collection([Country(alpha2: 'US', ...), ...])
```

#### Phone Numbers

##### `PhoneNumber.create`

Provision a new phone number.

``` ruby
PhoneNumber.create country_code: 1, area_code: 555
# => PhoneNumber(phone_number: '+15558675309', ...)
```

##### `PhoneNumber.list`

List phone numbers that you own on Phaxio.

``` ruby
PhoneNumber.list
# => Phaxio::Resource::Collection([PhoneNumber(phone_number: '+15558675309', ...), ...])
```

##### `PhoneNumber.get`

Get information about a specific phone number.

``` ruby
PhoneNumber.get '+15558675309'
# => PhoneNumber(phone_number: '+15558675309', ...)
```

##### `PhoneNumber.delete`

Release a phone number.

``` ruby
PhoneNumber.delete '+15558675309'
# => true
```

#### Area Codes

##### `AreaCode.list`

Lists available area codes for purchasing Phaxio numbers.

``` ruby
area_codes = AreaCode.list_available_area_codes toll_free: true
# => Phaxio::Resource::Collection([AreaCode(city: 'Chicago', ...), ...], page: 1)
```

#### PhaxCodes

##### `PhaxCode.create`

Creates a PhaxCode. Returns data about the PhaxCode by default, or a .png file if `type: 'png'` is
passed.

``` ruby
PhaxCode.create metadata: 'test_phax_code'
# => PhaxCode(identifier: 'phax-code-identifier')
PhaxCode.create type: 'png'
# => File
```

##### `PhaxCode.get`

Gets a PhaxCode. Returns data about the PhaxCode by default, or a .png file if `type: 'png'` is
passed.

``` ruby
PhaxCode.get 'phax-code-identifier'
# => PhaxCode(identifier: 'phax-code-identifier', metadata: 'phax-code-metadata')
PhaxCode.get 'phax-code-identifier', type: 'png'
# => File
```

#### Account

##### `Account.get`

Get information about your Phaxio account.

``` ruby
Account.get
# => Account(balance: 1000, faxes_today: 0, faxes_this_month: 100)
```

#### Callback

##### `Callback.valid_signature?`

Validate the callback signature sent with a Phaxio callback. Requires that Phaxio.callback_token be
set.

``` ruby
Callback.valid_signature? received_signature, callback_url, received_params, received_files
# => true
```

## Callback Validation Example with Sinatra

``` ruby
require 'sinatra/base'
require 'phaxio'

class PhaxioCallbackExample < Sinatra::Base
  Phaxio.config do |config|
    config.api_key = '0123456789'
    config.api_secret = '0123456789'
    config.callback_token = '0123456789'
  end

  post '/phaxio_callback' do
    signature = request.env['HTTP_X_PHAXIO_SIGNATURE']
    url = request.url
    file_params = params[:filename]
    if Phaxio::Callback.valid_signature? signature, url, callback_params, file_params
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
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Modified Semantic Versioning

Versions consist of four parts. The first corresponds to the supported Phaxio API version, the
second to the major version of the gem itself, the third to the minor version of the gem, and the
fourth to the patch level of the gem.
