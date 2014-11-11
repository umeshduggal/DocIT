xml.instruct!
xml.Response do
  xml.Say "I will now connect you.", :voice=>"woman", :language=> @language
  xml.Dial :hangupOnStar=> true do
    xml.Conference "#{current_user.mobile_number}", :endConferenceOnExit => true, :waitUrl => "http://twimlets.com/holdmusic?Bucket=com.twilio.music.classical"
  end
  
end
 