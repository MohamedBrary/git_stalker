module RspecApiDocumentation
  class RackTestClient < ClientBase
    def response_body
      last_response.body.encode("utf-8")
    end
  end
end

RspecApiDocumentation.configure do |config|
  # Change the embedded style for HTML output. This file will not be processed by
  # RspecApiDocumentation and should be plain CSS.
  config.html_embedded_css_file = File.join(Rails.root, 'doc', 'custom.css')
end
