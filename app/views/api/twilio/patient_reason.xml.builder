xml.instruct!
xml.Response do
  xml.Say "Please tell me in a few words the reason for your call, when you hear the beep.",
          :voice=>"woman", :language=> @language
  xml.Record :action=> @post_to, :maxLength=>"30",  :finishOnKey=>"#"
  xml.Say "I did not receive a recording"
  
end
