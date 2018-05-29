require 'test_helper'

class FacebookCanvas::MiddlewareTest < ActiveSupport::TestCase
  let(:middleware) { FacebookCanvas::Middleware.new(app, request_host, custom_filter, **kwargs) }
  let(:request_host) { %r{.*} }
  let(:custom_filter) { proc { |_env| true } }
  let(:kwargs) { {} }
  let(:app) { proc { |env| [200, {}, env] } }
  let(:env) {
    {
      "SERVER_NAME" => "test.host",
      "REQUEST_METHOD" => original_request_method,
    }
  }
  let(:original_request_method) { "POST" }

  describe "request_host" do
    describe "matching via regexp" do
      describe "matching any host" do
        let(:request_host) { %r{.*} }

        test "modifies request method to GET" do
          env["SERVER_NAME"] = "anything"
          assert_request_method "GET"
        end
      end

      describe "matching speficic host" do
        let(:request_host) { %r{\.fb\.} }

        test "modifies request method to GET if matched" do
          env["SERVER_NAME"] = "test.fb.host"
          assert_request_method "GET"
        end

        test "does not change request method" do
          env["SERVER_NAME"] = "test.facebook.host"
          refute_request_method_change
        end
      end
    end

    describe "matching via proc" do
      let(:request_host) do
        proc { |env| env[:pass_server_name] }
      end

      test "modifies request method to GET" do
        env[:pass_server_name] = true
        assert_request_method "GET"
      end

      test "does not change request method" do
        env[:pass_server_name] = false
        refute_request_method_change
      end
    end

    describe "matching via other objects" do
      let(:request_host) { :something }

      test "fails initialization with ArgumentError" do
        e = assert_raises ArgumentError do
          middleware
        end
        assert_equal "Expected Regexp or Proc for `request_host` but got: :something", e.message
      end
    end
  end

  describe "custom_filter" do
    let(:custom_filter) do
      proc { |env| env[:pass_custom_filter] }
    end

    test "modifies request method to GET if matched" do
      env[:pass_custom_filter] = true
      assert_request_method "GET"
    end

    test "prevents change of request method" do
      env[:pass_custom_filter] = false
      refute_request_method_change
    end
  end

  describe "with Rails' POST request" do
    before do
      env["rack.request.form_hash"] = {
        "utf8" => "✓"
      }
    end

    test "does not change request method" do
      refute_request_method_change
    end
  end

  describe "with Rails' XHR requests" do
    before do
      env["HTTP_X_REQUESTED_WITH"] = "XMLHttpRequest"
    end

    test "does not change request method" do
      refute_request_method_change
    end
  end

  describe "inside_filter" do
    describe "is optional" do
      test "modifies request method to GET if matched" do
        # no kwargs
        assert_request_method "GET"
      end
    end

    describe "is set" do
      before do
        kwargs[:inside_filter] = proc { |env| env[:pass_inside_filter] }
      end

      describe "accepted by the filter" do
        before do
          env[:pass_inside_filter] = true
        end

        test ".inside?(env) returns true" do
          _, _, new_env = middleware.call(env)
          assert FacebookCanvas::Middleware.inside?(new_env)
        end

        test "modifies request method to GET if matched" do
          assert_request_method "GET"
        end
      end

      describe "denied by the filter" do
        before do
          env[:pass_inside_filter] = false
        end
        test "does not change request method" do
          refute_request_method_change
        end
      end
    end
  end

  private

  def assert_request_method(expected)
    _status, _headers, body = middleware.call(env)

    assert_instance_of Hash, body
    assert_equal expected, body.fetch("REQUEST_METHOD")
  end

  def refute_request_method_change
    assert_request_method original_request_method
  end
end
