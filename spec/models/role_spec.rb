require 'spec_helper'

describe Role do
  it "has a valid factory" do
     expect( FactoryGirl.create(:role) ).to be_valid
  end

  it "is valid without a name" do
    expect( FactoryGirl.create(:role, name: nil) ).to be_valid
  end

  it "returns a historical event name as a string" do
    expect( FactoryGirl.create(:role, name: "Bob").name ).to eq( "Bob" )
  end
  
end