require 'rails_helper'

describe Note, type: :model do
  subject { FactoryGirl.create(:task) }

  it "has a valid factory" do
    admin = FactoryGirl.create(:admin)
    expect( subject.notes.create(attributes_for(:note, user_id: admin.id))).to be_valid
  end

  it "not be valid if author is nil" do
    note =  subject.notes.create(attributes_for(:note, user_id: nil))
    expect( note ).to_not be_valid
  end

  it "belongs to loggable" do
    assc = Note.reflect_on_association(:loggable)
    expect( assc.macro ).to eq :belongs_to
  end
end
