xml.instruct!
xml.Response do
    xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "10") do
        xml.Say "Press 1 for English Or press 2 for spanish.", :voice=>"woman"
    end
    xml.Redirect 
end
