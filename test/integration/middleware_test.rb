require 'test_helper'

class FacebookCanvas::MiddlewareTest < ActionDispatch::IntegrationTest
  test 'convert post to get request' do
    post '/foo/index'
    assert_response :success
  end

  test 'do not convert post' do
    post '/foo/create', { "utf8" => "utf" }
    assert_response :success
  end

  test 'do not convert xhr requests' do
    xhr :post, '/foo/create'
    assert_response :success
  end
end
