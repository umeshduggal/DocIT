module IntendedRecipientHelper
  def registered_column record
    record.registered? ?  image_tag(src = 'success-icon.png') : image_tag(src = 'failure-icon.png')
  end  
  
  def disabled_column record
    record.enabled? ?  image_tag(src = 'success-icon.png') : record.registered? ? image_tag(src = 'failure-icon.png') : 'N/A'
  end  
  
  def disabled_user record
    record.enabled? ?  link_to("Disable", user_action_path(record.id, enable: false), method: :post) : record.registered? ? link_to("Enable", user_action_path(record.id, enable: true), method: :post) : 'N/A'
  end
  
end
