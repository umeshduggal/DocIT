xml.instruct!
xml.Response do
    xml.Say "You are now connected with Patient",
            :voice=>"woman", :language=> @language
    xml.Play @recording_url
    xml.Dial :action => @post_to, :timeout => "30",:record=> "true" do
      xml.Conference "#{current_user.mobile_number}", :endConferenceOnExit => true
    end
end
