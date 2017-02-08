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
  
  it "transition from pending to route" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:pending).to(:en_route).on_event(:begin_route)
  end 
  
  it "transition from problem to route" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:problem).to(:en_route).on_event(:begin_route)
  end 
  
  it "transition from route to progress" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:en_route).to(:in_progress).on_event(:begin_working)
  end 
  
  it "transition from route to progress" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:en_route).to(:in_progress).on_event(:begin_working)
  end 
  
  it "transition from progress to complete" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:in_progress).to(:completed).on_event(:complete)
  end 
  
  it "transition from problem to complete" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:problem).to(:completed).on_event(:complete)
  end 
  
  it "transition from deactivated to problem" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:deactivated).to(:problem).on_event(:report_problem)
  end
  
  it "transition from pending to problem" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:pending).to(:problem).on_event(:report_problem)
  end
  
  it "transition from en_route to problem" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:en_route).to(:problem).on_event(:report_problem)
  end
  
  it "transition from in_progress to problem" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:in_progress).to(:problem).on_event(:report_problem)
  end
  
  it "transition from completed to problem" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:completed).to(:problem).on_event(:report_problem)
  end
  
  it "transition from deactivated to deactivated" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:deactivated).to(:deactivated).on_event(:deactivate)
  end
  
  it "transition from pending to deactivated" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:pending).to(:deactivated).on_event(:deactivate)
  end
  
  it "transition from en_route to deactivated" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:en_route).to(:deactivated).on_event(:deactivate)
  end
  
  it "transition from in_progress to deactivated" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:in_progress).to(:deactivated).on_event(:deactivate)
  end
  
  it "transition from completed to deactivated" do
    project = FactoryGirl.create(:project)
    expect(project).to transition_from(:completed).to(:deactivated).on_event(:deactivate)
  end
  
  it "total time for complete" do
    project = FactoryGirl.create(:project, resource_state: "completed")
    expect(project.total_time).to eq( 2 )
  end
  
  it "Test set_completion_date method works" do
    project = FactoryGirl.create(:project)
    project.set_completion_date
    expect( project.completion_date.strftime("%m/%d/%Y at %I:%M%p") ).to eq( DateTime.now.strftime("%m/%d/%Y at %I:%M%p") )
  end
  
  it "Test alert_level method work for inactive" do
    project = FactoryGirl.build(:project)
    expect( project.alert_level ).to eq ( "inactive" )
  end
  
  it "Test alert_level method work for inactive when task problem" do
    project = FactoryGirl.build(:project)
    FactoryGirl.create( :task, project: project, resource_state: "problem" )
    expect( project.alert_level ).to eq ( "inactive" )
  end
  
  it "Test alert_level method work for operatonal" do
    project = FactoryGirl.create(:project, resource_state: "problem")
    expect( project.alert_level ).to eq ( "operatonal" )
  end
  
  it "Test alert_level method work for advisory" do
    project = FactoryGirl.create(:project, resource_state: "problem")
    FactoryGirl.create( :task, project: project, resource_state: "problem" )
    expect( project.alert_level ).to eq ( "advisory" )
  end
  
  it "Test alert_level method work for danger" do
    project = FactoryGirl.create(:project, resource_state: "problem")
    FactoryGirl.create( :task, project: project, resource_state: "problem" )
    FactoryGirl.create( :task, project: project, resource_state: "problem" )
    expect( project.alert_level ).to eq ( "danger" )
  end
  
  it "Test alert_level method work for danger" do
    project = FactoryGirl.create(:project, resource_state: "problem")
    FactoryGirl.create( :task, project: project, resource_state: "problem" )
    FactoryGirl.create( :task, project: project, resource_state: "problem" )
    FactoryGirl.create( :task, project: project, resource_state: "problem" )
    expect( project.alert_level ).to eq ( "danger" )
  end
  
  it "Test flags for one flag" do
    project = FactoryGirl.create(:project, resource_state: "problem")
    FactoryGirl.create( :task, project: project, resource_state: "problem" )
    expect( project.flags.count ).to eq ( 1 )
  end
  
  it "Test flags for zero flag" do
    project = FactoryGirl.create(:project, resource_state: "problem")
    expect( project.flags.count ).to eq ( 0 )
  end
  
end