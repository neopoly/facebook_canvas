module Support
  module HttpMethodCompatibility
    def self.included(base)
      if Rails.version < '5.0.0'
        base.prepend OlderRails
      end
    end

    module OlderRails
      def post(action, params: {}, xhr: false)
        if xhr
          xml_http_request(:post, action, params)
        else
          super(action, params)
        end
      end
    end
  end
end
