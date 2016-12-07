module ApplicationHelper
    # Usage: <% title(STRING or method that returns STRING) %>
    def title(page_title)
        content_for :title, page_title.to_s
    end
end