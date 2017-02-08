require 'rails_helper'

describe GroupUser do

  it "has a valid factory" do
    expect( FactoryGirl.create(:group_user) ).to be_valid
  end
  
  it "is invalid without a user id" do
    expect{ FactoryGirl.create( :group_user, user: nil ) }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "is invalid without a group id" do
    expect{ FactoryGirl.create( :group_user, group: nil ) }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "belongs to project" do
    assc = described_class.reflect_on_association(:user)
    expect( assc.macro ).to eq :belongs_to
  end
  
  it "belongs to group" do
    assc = described_class.reflect_on_association(:group)
    expect( assc.macro ).to eq :belongs_to
  end
  
end