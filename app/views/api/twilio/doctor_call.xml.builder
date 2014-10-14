xml.instruct!
xml.Response do
  xml.Say "I will now connect you.", :voice=>"woman", :language=> @language
  xml.Dial :action => @post_to, :timeout => "30",:record=> "true" do
    xml.Number "#{current_user.mobile_number}", :url => @patient_info_url
  end
  xml.Hangup
end
 