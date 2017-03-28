require 'rails_helper'

describe Role, type: :model do
  it "has a valid factory" do
     expect( FactoryGirl.create(:role) ).to be_valid
  end

  it "be invalid without a name" do
    expect( FactoryGirl.build(:role, name: nil) ).not_to be_valid
  end

  it "returns a role name as a string" do
    expect( FactoryGirl.create(:role, name: "Bob").name ).to eq( "Bob" )
  end
end