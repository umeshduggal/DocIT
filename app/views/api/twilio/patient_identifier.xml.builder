xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
    xml.Say "Please state the patient's first name, ", :voice=>"woman", :language=> @language
    xml.Say " the patient's last name, ", :voice=>"woman", :language=> @language
    xml.Say " and the patient's date of birth when you hear the beep. Please press 1 to start recording", :voice=>"woman", :language=> @language
    xml.Say " and Once you complete the recording, ", :voice=>"woman", :language=> @language
    xml.Say " Please press 2. ", :voice=>"woman", :language=> @language
    end
    xml.Redirect @redirect_to
end
