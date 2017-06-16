require 'test_helper'

class FacebookCanvas::IntegrationMiddlewareTest < ActionDispatch::IntegrationTest
  test 'convert post to get request' do
    post '/foo/index'
    assert_response :success
  end

  test 'do not convert post' do
    post '/foo/create', params: { "utf8" => "utf" }
    assert_response :success
  end

  test 'do not convert xhr requests' do
    post '/foo/create', xhr: true
    assert_response :success
  end
end
