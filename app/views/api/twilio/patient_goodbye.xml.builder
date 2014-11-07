xml.instruct!
xml.Response do
    xml.Say "Goodbye!", :voice=>"woman", :language=> @language
    xml.Hangup
end
