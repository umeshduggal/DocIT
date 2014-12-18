xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
    xml.Say "Por favor, digame el motivo de su llamada, cuando escuche el sonido. Oprime numero uno para  empezar y oprime numero dos cuando terminado.",:voice=>"woman", :language=> @language
  end
  xml.Redirect @redirect_to
end
