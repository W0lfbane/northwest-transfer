class Document < ApplicationRecord
    belongs_to :project
    has_many :fields, as: :fieldable
  
    validates :title, presence: true
end