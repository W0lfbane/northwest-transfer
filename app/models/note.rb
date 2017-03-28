class Note < Log
  belongs_to :loggable, polymorphic: true
  
  validates :author, presence: true
end