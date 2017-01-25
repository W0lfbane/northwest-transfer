class DocumentType < ApplicationRecord
    belongs_to :document
    has_many :fields, as: :fieldable
end
