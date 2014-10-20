xml.instruct!
xml.Response do
    xml.Say "Please state the patient's first name,", :voice=>"woman", :language=> @language
    xml.Say " the patient's last name,   ", :voice=>"woman", :language=> @language
    xml.Say " and the patient's date of birth when you hear the beep.  ", :voice=>"woman", :language=> @language
    xml.Say " Once you complete, ", :voice=>"woman", :language=> @language
    xml.Say " Please press # . ", :voice=>"woman", :language=> @language
    xml.Record :action=> @post_to, :method=>"GET", :maxLength=>"30", :finishOnKey=>"#"
    xml.Say "I did not receive a recording",:voice=>"woman", :language=> @language
    xml.Redirect @redirect_to   
end
