xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "Charges for a consultation for less then 5 minutes $#{@charges[1]}", :voice=>"woman", :language=> @language
      xml.Say "for 5 to 10 minutes $#{@charges[2]}", :voice=>"woman", :language=> @language
      xml.Say "for 10 to 20 minutes $#{@charges[3]}", :voice=>"woman", :language=> @language
      xml.Say "for 20 to 30 minutes $#{@charges[4]}", :voice=>"woman", :language=> @language
      xml.Say "for greater then 30 minutes $#{@charges[5]}", :voice=>"woman", :language=> @language
      xml.Pause :length => "2"
      xml.Say "Go back to previous menu, press 1", :voice=>"woman", :language=> @language
      xml.Say " or press any key to repeat this menu", :voice=>"woman", :language=> @language
    end
  xml.Redirect @post_to+"?Digits=2"
end
