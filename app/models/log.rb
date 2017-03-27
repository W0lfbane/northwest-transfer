class Log < ApplicationRecord
  validates :text, presence: true
end
