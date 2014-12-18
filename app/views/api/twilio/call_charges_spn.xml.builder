xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "Para una conversación menos de cinco minutos, se le puede cobrar #{@charges[1]} dólares", :voice=>"woman", :language=> @language
      xml.Say "Para una conversación cinco minutos a diez minutos se le puede cobrar #{@charges[2]} dólares", :voice=>"woman", :language=> @language
      xml.Say "Para una conversación diez a viente minutos, se le puede cobrar #{@charges[3]} dólares", :voice=>"woman", :language=> @language
      xml.Say "Para una conversacion viente a treinta minutos, se le puede cobrar #{@charges[4]} dólares", :voice=>"woman", :language=> @language
      xml.Say "Para una conversacion mas de treinta minutos, se le puede cobrar #{@charges[5]} dólares", :voice=>"woman", :language=> @language
      xml.Pause :length => "2"
      xml.Say "Si usted está listo para hablar con #{current_user.name}, oprime el numero uno.",:voice=>"woman", :language=> @language
      xml.Say "Para repetir este mensaje, oprime el numero dos", :voice=>"woman", :language=> @language
    end
  xml.Redirect @post_to+"?Digits=2"
end
