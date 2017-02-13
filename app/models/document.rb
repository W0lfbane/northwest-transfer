class Document < ApplicationRecord
    belongs_to :project
    has_many :fields, as: :fieldable
    has_one :extendible_resource, as: :extensible
  
    validates :title, presence: true
end