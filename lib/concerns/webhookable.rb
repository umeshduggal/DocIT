module Webhookable
extend ActiveSupport::Concern

 #Setting the HTTP response content type to “text/xml”
  def set_header
          response.headers["Content-Type"] = "text/xml"
  end
 #Rendering the TwiML object to raw XML
  def render_twiml(response)
      render text: response.text
  end
 
end