class ResourceField < ApplicationRecord
  belongs_to :fieldable, polymorphic: true
end
