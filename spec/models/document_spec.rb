require 'rails_helper'

describe Document do
  it "has a valid factory" do
    expect( FactoryGirl.create(:document) ).to be_valid
  end

  it "is invalid without a title" do
    expect( FactoryGirl.build(:document, title: nil) ).not_to be_valid
  end

  it "returns a historical event title as a string" do
    expect( FactoryGirl.create(:document, title: "Bob").title ).to eq( "Bob" )
  end
  
  it "belongs to project" do
    assc = described_class.reflect_on_association(:project)
    expect( assc.macro ).to eq :belongs_to
  end
  
end