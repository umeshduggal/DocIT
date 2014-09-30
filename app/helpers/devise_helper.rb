# To change this template, choose Tools | Templates
# and open the template in the editor.

module DeviseHelper

  def devise_error_messages!
    if flash[:error].nil? 
      flash.now[:error] = "<li>#{resource.errors.full_messages.join("</li><li>")}</li>" unless resource.errors.full_messages.blank?
    else
      flash.now[:error].concat "<li>#{resource.errors.full_messages.join("</li><li>")}</li>" unless resource.errors.full_messages.blank?
    end
  end
end