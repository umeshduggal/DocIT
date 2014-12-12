xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
    xml.Say "Por favor, dígame en pocas palabras el motivo de su llamada cuando escucha el sonido .",:voice=>"woman", :language=> @language
    xml.Say " Por favor, pulse 1 para iniciar la grabación y una vez que haya completado la grabación, pulse favor, 2 .", :voice=>"woman", :language=> @language
  end
  xml.Redirect @redirect_to
end
