require 'rails_helper'

describe Log, type: :model do
  it "have a valid factory" do
    expect(FactoryGirl.build(:log)).to be_valid
  end

  it "validate the prences of text field" do
    expect(FactoryGirl.build(:log, text: nil)).not_to be_valid
  end
end
