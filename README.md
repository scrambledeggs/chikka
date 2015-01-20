chikka
======

A Ruby gem for consuming the [Chikka API](https://api.chikka.com) for sending mesages

## Requirements

  Ruby 2.x.x

## Installation

    $ gem install chikka

## Usage

Construct a Chikka::Client object and use the #send_message method to
send a message. For example:

```ruby
require 'chikka'

client = Chikka::Client.new(client_id:'key', secret_key:'secret', shortcode:'shortcode')
client.send_message(message:'This is a test', mobile_number:'639171234567')
```

By default, the client creates a random unique 32 character string as the message_id.

A message_id parameter can be specified and used for [delivery notifications](https://api.chikka.com/docs/handling-messages#delivery-notifications)

```ruby
client.send_message(message:'This is a test', mobile_number:'639171234567', message_id:'75c09eb7581588f578624ad9538cc6d3')
```

For replies, the #send_reply method can be used. It is similar to the #send_message call but accepts request_id and request_cost. request_cost is optional and it defaults to 'FREE'
```ruby
client.send_reply(message:'This is a test', mobile_number:'639171234567', request_id: '504830303...83137', request_cost: 'P5.00')
```

## Production environment variables

Best practice for storing credentials for external services in production is
to use environment variables, as described by [12factor.net/config](http://12factor.net/config).
Client::Client defaults to extracting the client_id, secret_key and shortcode it needs from the
CHIKKA_CLIENT_ID,  CHIKKA_SECRET_KEY and CHIKKA_SHORTCODE environment variables if the
options were not specified explicitly.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b new-feature`)
3. Commit your changes (`git commit -am 'Added awesome new features'`)
4. Push to the branch (`git push origin new-feature`)
5. Create new Pull Request
6. ???
7. Profit

## MIT Open Source License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Acknowledgement
Originally created for use on [Booky -Manila Restaurants](http://ph.phonebooky.com/)

2015 [Scrambled Eggs Pte Ltd](http://www.eggsapps.com)