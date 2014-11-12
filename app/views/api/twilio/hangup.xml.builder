xml.instruct!
xml.Response do
    xml.Say "Sorry, I have not received any input from you. Good bye.", :voice=>"woman", :language=> @language
    xml.Hangup
end
