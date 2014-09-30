xml.instruct!
xml.Response do
    xml.Gather(:action => @post_to, :numDigits => 2) do
        xml.Say "Hello, Dr #{current_user.name} is returning your call.  This call may be recorded and billed.  To continue press 1", :voice=>"woman"
    end
end
