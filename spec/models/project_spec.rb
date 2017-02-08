require 'rails_helper'

describe Project do

  it "has a valid factory" do
    expect( FactoryGirl.create(:project) ).to be_valid
  end
  
  it "is invalid without a title" do
    expect( FactoryGirl.build(:project, title: nil) ).not_to be_valid
  end

  it "is invalid without a description" do
    expect( FactoryGirl.build(:project, description: nil) ).not_to be_valid
  end
  
  it "is invalid without a location" do
    expect( FactoryGirl.build(:project, location: nil) ).not_to be_valid
  end
  
  it "is invalid without a start_date" do
    expect( FactoryGirl.build(:project, start_date: nil) ).not_to be_valid
  end
  
  it "is invalid without a estimated_completion_date" do
    expect( FactoryGirl.build(:project, estimated_completion_date: nil) ).not_to be_valid
  end
  
  it "returns a project title as a string" do
    expect( FactoryGirl.create(:project, title: "Bob").title ).to eq( "Bob" )
  end
  
  it "returns a project description as a string" do
    expect( FactoryGirl.create(:project, description: "Bob").description ).to eq( "Bob" )
  end
  
  it "returns a project location as a string" do
    expect( FactoryGirl.create(:project, location: "Bob").location ).to eq( "Bob" )
  end
  
  it "returns a project start_date as a date" do
    expect( FactoryGirl.create(:project, start_date: "2001-1-1").start_date ).to eq( "2001-1-1".to_date )
  end
  
  it "returns a project estimated_completion_date as a date" do
    expect( FactoryGirl.create(:project, estimated_completion_date: "2001-1-1").estimated_completion_date ).to eq( "2001-1-1".to_date )
  end
  
  it "returns a project completion_date as a date" do
    expect( FactoryGirl.create(:project, completion_date: "2001-1-1").completion_date ).to eq( "2001-1-1".to_date )
  end
  
   it "error when task resource_state is not part of the list like 'pending'" do
    expect{ FactoryGirl.create( :project, resource_state: "Bob" ) }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "change the pending to completed for project resource_state" do
    expect( FactoryGirl.create(:project, resource_state: "completed").resource_state ).to eq( "completed" )
  end
  
  it "change the pending to problem for project resource_state" do
    expect( FactoryGirl.create(:project, resource_state: "problem").resource_state ).to eq( "problem" )
  end
  
  it "check pending for project resource_state" do
    expect( FactoryGirl.create(:project).resource_state ).to eq( "pending" )
  end
  
end