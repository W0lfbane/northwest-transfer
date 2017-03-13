class Note < Log
  belongs_to :logable, polymorphic: true
  
  validates :author, presence: true
end
