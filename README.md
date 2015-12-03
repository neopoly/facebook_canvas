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

All requests coming from Facebook to the canvas are `POST` requests.
So a way is needed to handle those request in the application.

## How?

First check wether the request was originally a `GET` request.
For that we assume that Rails inserts a hidden parameter with UTF8 for all non `GET` requests.
So if this parameter is missing, the request is a `GET` request and therefor the `REQUEST_METHOD` is set to `GET`.

The second action which this enigne does, is to save the `SIGNED_REQUEST` in the `default_url_options` hash.
So you have access about the user over the entire application.

## Installation

### `Gemfile`

```ruby
gem 'facebook_canvas'
```

## Configuration

In your Rails application you can set the server name in which the application runs for Facebook canvas.
The default value is set to: `/\.fb\./`

```ruby
FacebookCanvas.server_name = /SERVERNAME/
```

## Ruby support

This gem supports Ruby version 2.1 and 2.2.
