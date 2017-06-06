[github]: https://github.com/neopoly/facebook_canvas
[doc]: http://rubydoc.info/github/neopoly/facebook_canvas/master/file/README.md
[gem]: https://rubygems.org/gems/facebook_canvas
[travis]: https://travis-ci.org/neopoly/facebook_canvas
[codeclimate]: https://codeclimate.com/github/neopoly/facebook_canvas
[inchpages]: https://inch-ci.org/github/neopoly/facebook_canvas

# FacebookCanvas

[![Travis](https://img.shields.io/travis/neopoly/facebook_canvas.svg?branch=master)][travis]
[![Gem Version](https://img.shields.io/gem/v/facebook_canvas.svg)][gem]
[![Code Climate](https://img.shields.io/codeclimate/github/neopoly/facebook_canvas.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/neopoly/facebook_canvas/badges/coverage.svg)][codeclimate]
[![Inline docs](https://inch-ci.org/github/neopoly/facebook_canvas.svg?branch=master&style=flat)][inchpages]

Make your Rails application fit to run in a Facebook canvas.


## Why?

Web apps need to handle both `GET` and `POST` requests, but in Facebook canvas apps all requests coming from Facebook are `POST` requests. `FacebookCanvas` provides a way to differentiate between `GET` and `POST` anyway.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'facebook_canvas'
```


## Configuration

`FacebookCanvas.server_name` is a regular expression that matches the url to your Facebook *Secure Canvas URL*.

The default value is set to: `/.*/`.
This means that it works for any *Secure Canvas URL*.

`FacebookCanvas.custom_filter` is a block called by the middleware to prevent rewriting of the `REQUEST_METHOD`.
The default value is set to: `proc { |env| true }`.
This means that every non-`GET` request (which matches the configured `server_name` above) will be
rewritten to `GET` if the UTF8 parameter is missing.

`FacebookCanvas.inside_filter` is a block called by the middleware to determine whether a request is "inside" (via `FacebookCanvas::Middleware.inside?(request)`) a facebook canvas.
This might be useful, if your application wants to behave differently whether (or not) a request is coming from facebook canvas.

The default value is set to: `proc { |env| true }`.
This means that every request is treated as "inside" of a facebook canvas.


If you want to use a specific *Secure Canvas URL* (or any other configuration), set the regular expression for `FacebookCanvas.server_name` inside an initializer:

```ruby
# config/initializers/facebook_canvas.rb

# treat URLs like http://fb.myproject.com as Facebook canvas requests
FacebookCanvas.server_name = /\.fb\./

# Do not rewrite POST requests from Facebook to "/facebook_realtime_updates"
FacebookCanvas.custom_filter = proc do |env|
  env['PATH_INFO'] !~ %r{^/facebook_realtime_updates}
end

# Determine whether a request is "inside" facebook canvas
FacebookCanvas.inside_filter = proc do |env|
  # Pull from session or request host or ...
end
```


## How does this work?

First check whether the request was originally a `GET` request.
For that we assume that Rails inserts a hidden parameter with UTF8 for all non `GET` requests.
So if this parameter is missing, the request is a `GET` request and therefor the `REQUEST_METHOD` is set to `GET`.

The second action which this enigne does, is to save the `SIGNED_REQUEST` in the `default_url_options` hash.
So you have access about the user over the entire application.

### XHR requests

All `XHR` requests (with header `X-REQUESTED-WITH` set to `XMLHttpRequest`) are not modified.

## Ruby support

This gem supports Ruby version 2.1 and 2.2.


## Contributing

1. [Fork it!](http://github.com/neopoly/facebook_canvas/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

FacebookCanvas is released under the MIT License. See the MIT-LICENSE file for further
details.

## Release

Follow these steps to release this gem:

    # Bump version in
    edit lib/facebook_canvas/version.rb
    edit README.md

    git commit -m "Release vX.Y.Z"

    rake release
