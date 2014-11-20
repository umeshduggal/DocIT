xml.instruct!
xml.Response do
    xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
        xml.Say "Hello, #{current_user.name} is returning your call. ", :voice=>"woman"
        xml.Say "This call may be recorded and billed. ", :voice=>"woman"
        xml.Say "To continue press 1. ", :voice=>"woman"
    end
    xml.Redirect @redirect_to
end
