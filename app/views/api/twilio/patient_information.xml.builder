xml.instruct!
xml.Response do
    xml.Say "You are now connected with Patient",
            :voice=>"woman", :language=> @language
    xml.Play @recording_url
    xml.Say "BEEP", :voice=>"woman", :language=> @language
end
