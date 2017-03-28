class Note < Log
  include Concerns::Polymorphic::Helpers
  
  belongs_to :loggable, polymorphic: true
  
  validates :author, presence: true
end