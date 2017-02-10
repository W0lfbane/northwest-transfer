require 'rails_helper'

describe Task, type: :model do

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
  
  it "change the pending to completed for task resource_state" do
    expect( FactoryGirl.create(:task, resource_state: "completed").resource_state ).to eq( "completed" )
  end
  
  it "change the pending to problem for task resource_state" do
    expect( FactoryGirl.create(:task, resource_state: "problem").resource_state ).to eq( "problem" )
  end
  
  it "check pending for task resource_state" do
    expect( FactoryGirl.create(:task).resource_state ).to eq( "pending" )
  end
  
  it "is invalid without a project id" do
    expect{ FactoryGirl.create( :task, project: nil ) }.to raise_error(ActiveRecord::RecordInvalid)
  end
  
  it "belongs to project" do
    assc = described_class.reflect_on_association(:project)
    expect( assc.macro ).to eq :belongs_to
  end
  
  it "transition from pending to completed" do
    task = FactoryGirl.create(:task)
    expect(task).to transition_from(:pending).to(:completed).on_event(:complete)
  end 
  
  it "transition from pending to report problem" do
    task = FactoryGirl.create(:task)
    expect(task).to transition_from(:pending).to(:problem).on_event(:report_problem)
  end 
  
end