xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
    xml.Say "Please tell me in a few words",:voice=>"woman", :language=> @language
    xml.Say "the reason for your call,  ",:voice=>"woman", :language=> @language
    xml.Say "when you hear the beep. ", :voice=>"woman", :language=> @language
    xml.Say "Please press 1 to start recording ", :voice=>"woman", :language=> @language
    xml.Say " and Once you complete the recording, ", :voice=>"woman", :language=> @language
    xml.Say " Please press 2. ", :voice=>"woman", :language=> @language
  end
  xml.Redirect @redirect_to
end
