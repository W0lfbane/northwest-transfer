require 'rails_helper'

describe GroupProject do

  it "has a valid factory" do
    expect( FactoryGirl.create(:group_project) ).to be_valid
  end
  
  it "is invalid without a project id" do
    expect{ FactoryGirl.create( :group_project, project: nil ) }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "is invalid without a group id" do
    expect{ FactoryGirl.create( :group_project, group: nil ) }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "belongs to project" do
    assc = described_class.reflect_on_association(:project)
    expect( assc.macro ).to eq :belongs_to
  end
  
  it "belongs to group" do
    assc = described_class.reflect_on_association(:group)
    expect( assc.macro ).to eq :belongs_to
  end
  
end