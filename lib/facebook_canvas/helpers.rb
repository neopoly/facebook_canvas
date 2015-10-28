module FacebookCanvas
  module Helpers
    def default_url_options
      if signed_request = params[:signed_request]
        super.merge({ :signed_request => signed_request })
      else
        super
      end
    end
  end
end
