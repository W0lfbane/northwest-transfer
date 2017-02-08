require 'rails_helper'

describe Group do

  it "has a valid factory" do
    expect( FactoryGirl.create(:group) ).to be_valid
  end
  
  it "is invalid without a name" do
    expect( FactoryGirl.build(:group, name: nil) ).not_to be_valid
  end

  it "returns a group name as a string" do
    expect( FactoryGirl.create(:group, name: "Bob").name ).to eq( "Bob" )
  end
  
  it "is valid without a description" do
    expect( FactoryGirl.create(:group, description: nil) ).to be_valid
  end
end