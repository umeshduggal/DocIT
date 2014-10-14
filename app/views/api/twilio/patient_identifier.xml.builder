xml.instruct!
xml.Response do
    xml.Say "Please state the patient's first name, the patient's last name, 
      and the patient's date of birth when you hear the beep (this is the Patient Identifier).",
            :voice=>"woman", :language=> @language
    xml.Record :action=> @post_to, :method=>"GET", :maxLength=>"30", :finishOnKey=>"#"
    xml.Say "I did not receive a recording",:voice=>"woman", :language=> @language
    xml.Redirect @redirect_to   
end
