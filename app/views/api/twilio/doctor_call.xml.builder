xml.instruct!
xml.Response do
  xml.Say "I will now connect you.", :voice=>"woman", :language=> @language
  xml.Dial :hangupOnStar=> true do
    xml.Conference "#{@call_log_id}", :endConferenceOnExit => true, :waitUrl => "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical"
  end
  
end
 