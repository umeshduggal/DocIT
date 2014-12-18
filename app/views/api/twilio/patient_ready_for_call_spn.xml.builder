xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "Si usted está listo para hablar con #{current_user.name}, oprime el numero uno. ",:voice=>"woman", :language=> @language
      xml.Say "Para escuchar una lista de posibles cargos,  oprime el numero  cinco. Para empezar de nuevo, oprime el número nueve",:voice=>"woman", :language=> @language
  end
  xml.Redirect @redirect_to
end
