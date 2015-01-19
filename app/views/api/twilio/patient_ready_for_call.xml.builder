xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "If you are ready to be connected to #{current_user.name}, ",:voice=>"woman", :language=> @language
      xml.Say "please press 1, at anytime. ",:voice=>"woman", :language=> @language
      xml.Pause :length => "1"
      xml.Say "By pressing 1, you are consenting to a billed consultation that may be billed directly to you, and understand that charges may not be covered by your insurance company.  Likewise, you agree that you will not seek reimbursement from your insurance company and hold the practice harmless if they do not submit a service claim to your insurance company.",:voice=>"woman", :language=> @language
      xml.Say "To hear a list of possible charges please press 5. ",:voice=>"woman", :language=> @language
      xml.Say "To start again, press 9. ",:voice=>"woman", :language=> @language
  end
  xml.Redirect @redirect_to
end
