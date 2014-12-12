xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "Si usted está listo para hablar con el #{current_user.name}, ",:voice=>"woman", :language=> @language
      xml.Say "por favor oprime  el numero  1. ",:voice=>"woman", :language=> @language
      xml.Say "Para escuchar una lista de posibles cargos, por favor oprime el numero  5.",:voice=>"woman", :language=> @language
      xml.Say "Para empezar de nuevo, presione 9.",:voice=>"woman", :language=> @language
  end
  xml.Redirect @redirect_to
end
