require 'rails_helper'

describe Task do
    
  subject { FactoryGirl.build(:beacon) }
    
  it "has a valid factory" do
    expect( FactoryGirl.create(:task) ).to be_valid
  end
  
  it "is invalid without a name" do
    expect( FactoryGirl.create(:task, name: nil) ).to be_valid
  end

  it "returns a task name as a string" do
    expect( FactoryGirl.create(:task, name: "Bob").name ).to eq( "Bob" )
  end
  
  it "is valid without a description" do
    expect( FactoryGirl.create(:task, description: nil) ).to be_valid
  end

  it "returns a task description as a string" do
    expect( FactoryGirl.create(:task, description: "Bob").description ).to eq( "Bob" )
  end
  
  it "is valid without a notes" do
    expect( FactoryGirl.create(:task, notes: nil) ).to be_valid
  end

  it "returns a task notes as a string" do
    expect( FactoryGirl.create(:task, notes: "Bob").notes ).to eq( "Bob" )
  end
  
  it "is valid without a resource_state" do
    expect( FactoryGirl.create(:task, resource_state: nil) ).to be_valid
  end

  it "error when task resource_state is not part of the list like 'pending'" do
    expect{ FactoryGirl.create( :task, resource_state: "Bob" ) }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "is invalid without a project id" do
    expect{ FactoryGirl.create( :task, project: nil ) }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "belongs to project" do
    assc = described_class.reflect_on_association(:project)
    expect( assc.macro ).to eq :belongs_to
  end
  
end