xml.instruct!
xml.Response do
  xml.Gather(:action => @post_to, :numDigits => 1, :timeout => "5") do
      xml.Say "Si usted está listo para hablar con #{current_user.name}, oprime el numero uno. ",:voice=>"woman", :language=> @language
      xml.Pause :length => "1"
      xml.Say "Cuando marque el numero uno, esta consintiendo a una consulta facturado que puede ser facturado directamente a usted, y que usted entiende que puede ser que unos cargos no estén cubridos por su seguro. Igualmente, usted esta de acuerdo que no va a buscar reembolso del seguro y que la practica no sera culpable si no mandan un reclamo de servicios a su seguro. Para oír una lista de cargos, marque el numero cinco. Para oír todo de nuevo, marque el nueve. Para conectarse con alguien ahora, marque uno.",:voice=>"woman", :language=> @language
  end
  xml.Redirect @redirect_to
end
