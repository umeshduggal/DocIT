xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "Para una conversación menos de 5 minutos, se le puede cobrar #{@charges[1]} dólares", :voice=>"woman", :language=> @language
      xml.Say "Para una conversación 5 minutos a 10 minutos se le puede cobrar #{@charges[2]} dólares", :voice=>"woman", :language=> @language
      xml.Say "Para una conversación 10-20minutes, se le puede cobrar #{@charges[3]} dólares", :voice=>"woman", :language=> @language
      xml.Say "Para una conversacion 20-30 minutos, se le puede cobrar #{@charges[4]} dólares", :voice=>"woman", :language=> @language
      xml.Say "Para una conversacion mas de 30 minutos, se le puede cobrar #{@charges[5]} dólares", :voice=>"woman", :language=> @language
      xml.Pause :length => "2"
      xml.Say "Para comunicarse con el  #{current_user.name},  por favor presione el numero 1, ",:voice=>"woman", :language=> @language
      xml.Say "Para repetir este mensaje oprime el numero 2", :voice=>"woman", :language=> @language
    end
  xml.Redirect @post_to+"?Digits=2"
end
