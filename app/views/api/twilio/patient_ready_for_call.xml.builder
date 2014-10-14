xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "If you are ready to be connected to Dr #{current_user.name}, please press 1. To hear a list of possible charges please press 5. To start again, press 9.",:voice=>"woman", :language=> @language
  end
  xml.Redirect @redirect_to
end
