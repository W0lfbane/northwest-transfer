module Modules::BootstrapFlashMessages
    # For Bootstrap flash messages
    BOOTSTRAP_FLASH_MSG = {
        success: 'alert-success',
        error: 'alert-danger',
        alert: 'alert-info',
        notice: 'alert-warning'
    }

    def bootstrap_class_for(flash_type)
        BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym)
    end
    
    def flash_messages(opts = {})
        flash.each do |msg_type, message|
            concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
            concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
            concat message 
            end)
        end
        nil
    end
end