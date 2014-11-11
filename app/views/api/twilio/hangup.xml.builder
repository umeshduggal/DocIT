xml.instruct!
xml.Response do
    xml.Say "We have not received any input for you. Goodbye.", :voice=>"woman", :language=> @language
    xml.Hangup
end
