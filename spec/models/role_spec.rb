require 'rails_helper'

describe Role, type: :model do
  it "has a valid factory" do
     expect( FactoryGirl.create(:role) ).to be_valid
  end

  it "is valid without a name" do
    expect( FactoryGirl.create(:role, name: nil) ).to be_valid
  end

  it "returns a role name as a string" do
    expect( FactoryGirl.create(:role, name: "Bob").name ).to eq( "Bob" )
  end
  
end