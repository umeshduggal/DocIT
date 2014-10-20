xml.instruct!
xml.Response do
    xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
        xml.Say " Press 1 for English.  ", :voice=>"woman"
        xml.Say " Or press 2 for spanish. ", :voice=>"woman"
    end
    xml.Redirect @redirect_to
end
