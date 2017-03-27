module Modules::DateTimeFormats
    def format_date_with_time(datetime)
        datetime.strftime("%m/%d/%Y at %I:%M%p")
    end
end