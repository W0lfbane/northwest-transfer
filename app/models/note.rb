class Note < Log
  include Concerns::Polymorphic::Helpers
  
  belongs_to :loggable, polymorphic: true, optional: true
  belongs_to :user

  validates :user, presence: true
  
  def author
    user.name
  end
end
