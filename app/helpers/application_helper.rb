module ApplicationHelper
    # Usage: <% title(STRING or method that returns STRING) %>
    def title(page_title)
        content_for :title, page_title.to_s
    end

    # For Bootstrap flash messages
    BOOTSTRAP_FLASH_MSG = {
        success: 'alert-success',
        error: 'alert-error',
        alert: 'alert-block',
        notice: 'alert-info'
    }

    def bootstrap_class_for(flash_type)
        BOOTSTRAP_FLASH_MSG.fetch(flash_type, flash_type.to_s)
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