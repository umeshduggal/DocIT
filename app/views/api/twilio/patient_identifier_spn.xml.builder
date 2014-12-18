xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
    xml.Say "Esta conversación con su especialista puede ser registrada y pueden cobrarle.", :voice=>"woman", :language=> @language
    xml.Say "Por favor, dígame el nombre completo de la paciente, y la fecha de nacimiento de la paciente, cuando escuche el sonido. Oprime numero uno para empezar y oprime numero dos cuando terminado", :voice=>"woman", :language=> @language
    
    end
    xml.Redirect @redirect_to
end
