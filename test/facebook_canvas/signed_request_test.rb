require 'test_helper'

class FacebookCanvas::SignedRequestTest < ActiveSupport::TestCase
  let(:secret) { "98fb1a9ca7385d4869f2a4a071ab6c32" }
  let(:signed_request) { fixture("signed_request.txt").strip }
  let(:signed_request_user) { fixture("signed_request_with_user_id.txt").strip }

  test "initialize" do
    assert FacebookCanvas::SignedRequest.new(signed_request_user, secret)
  end

  test "get user_id from signed request" do
    signed_request_parser = FacebookCanvas::SignedRequest.new(signed_request_user, secret)

    assert signed_request_parser.user_id
  end

  test "no user_id from signed request" do
    signed_request_parser = FacebookCanvas::SignedRequest.new(signed_request, secret)

    refute signed_request_parser.user_id
  end

  private

  def fixture(name)
    File.read FacebookCanvas::Engine.root.join("test", "fixtures", name)
  end
end
