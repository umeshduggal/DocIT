xml.instruct!
xml.Response do
  xml.Dial :action => @post_to, :timeout => "30" do
    xml.Number "#{current_user.mobile_number}", :url => @registration_info
  end
  xml.Hangup
end
 