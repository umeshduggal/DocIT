xml.instruct!
xml.Response do
    xml.Record :action=> @post_to, :method=>"GET",:timeout=> "5", :maxLength=>"30", :finishOnKey=>"2"
    xml.Say "I did not receive a recording", :voice=>"woman", :language=> @language
    xml.Redirect @redirect_to   
end
