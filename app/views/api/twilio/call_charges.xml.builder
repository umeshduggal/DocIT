xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "Charges for a consultation for less then 5 minutes $#{@charges[1]}", :voice=>"woman", :language=> @language
      xml.Say "for 5 to 10 minutes $#{@charges[2]}", :voice=>"woman", :language=> @language
      xml.Say "for 10 to 20 minutes $#{@charges[3]}", :voice=>"woman", :language=> @language
      xml.Say "for 20 to 30 minutes $#{@charges[4]}", :voice=>"woman", :language=> @language
      xml.Say "for greater then 30 minutes $#{@charges[5]}", :voice=>"woman", :language=> @language
      xml.Pause :length => "2"
      xml.Say "If you are ready to be connected to #{current_user.name}, ",:voice=>"woman", :language=> @language
      xml.Say "please press 1, ",:voice=>"woman", :language=> @language
      xml.Say " to repeat the possible charges please press 2", :voice=>"woman", :language=> @language
    end
  xml.Redirect @post_to+"?Digits=2"
end
