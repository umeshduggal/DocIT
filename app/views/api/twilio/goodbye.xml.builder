xml.instruct!
xml.Response do
    xml.Say "We are sorry but Dr #{current_user.name} is no longer able to pick up the phone, we will leave a message. Goodbye", :voice=>"woman", :language=> @language
    xml.Hangup
end
