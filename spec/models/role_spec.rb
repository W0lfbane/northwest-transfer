require 'rails_helper'

describe Role do
  it "has a valid factory" do
     expect( FactoryGirl.create(:role) ).to be_valid
  end

  it "be invalid without a name" do
    expect( FactoryGirl.build(:role, name: nil) ).not_to be_valid
  end

  it "returns a role name as a string" do
    expect( FactoryGirl.create(:role, name: "Bob").name ).to eq( "Bob" )
  end

  it "have relation has and belongs to many with users" do
    assc = Role.reflect_on_association(:users)
    expect( assc.macro ).to eq :has_and_belongs_to_many
  end

  it "have association with resources" do
    assc = Role.reflect_on_association(:resource)
    expect( assc.macro ).to eq :belongs_to
  end
end