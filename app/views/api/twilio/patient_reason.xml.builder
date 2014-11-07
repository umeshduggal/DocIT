xml.instruct!
xml.Response do
  xml.Say "Please tell me in a few words",:voice=>"woman", :language=> @language
  xml.Say "the reason for your call,  ",:voice=>"woman", :language=> @language
  xml.Say "when you hear the beep. ", :voice=>"woman", :language=> @language
  xml.Say "Once you complete, ", :voice=>"woman", :language=> @language
  xml.Say "Please press #. ", :voice=>"woman", :language=> @language
  xml.Record :action=> @post_to, :timeout=> "3", :maxLength=>"30",  :finishOnKey=>"#"
  xml.Say "I did not receive a recording", :voice=>"woman", :language=> @language
  xml.Redirect @redirect_to   
end
