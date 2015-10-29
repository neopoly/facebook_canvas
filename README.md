# FacebookCanvas

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
