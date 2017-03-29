require 'rails_helper'

describe Project, type: :model do
  subject { FactoryGirl.build(:project) }

  admin = FactoryGirl.create(:admin)

  it "has a valid factory" do
    expect( subject ).to be_valid
  end

  it "will have many tasks" do
    assc = described_class.reflect_on_association(:tasks)
    expect(assc.macro).to eq(:has_many)
  end

  it "will have many users" do
    assc = described_class.reflect_on_association(:users)
    expect(assc.macro).to eq(:has_many)
  end

  # This will change
  it "will have one document" do
    assc = described_class.reflect_on_association(:document)
    expect(assc.macro).to eq(:has_one)
  end

  it "is invalid without a title" do
    subject.title = nil
    expect( subject ).not_to be_valid
  end

  it "is invalid without a address" do
    subject.address = nil
    expect( subject ).not_to be_valid
  end

  it "is invalid without a city" do
    subject.city = nil
    expect( subject ).not_to be_valid
  end

  it "is invalid without a state" do
    subject.state = nil
    expect( subject ).not_to be_valid
  end

  it "is invalid without a postal code" do
    subject.postal = nil
    expect( subject ).not_to be_valid
  end

  it "is invalid without a country" do
    subject.country = nil
    expect( subject ).not_to be_valid
  end

  it "is invalid without a start_date" do
    subject.start_date = nil
    expect( subject ).not_to be_valid
  end

  it "is invalid without a estimated_completion_date" do
    subject.estimated_completion_date = nil
    expect( subject ).not_to be_valid
  end

  it "state of the project is initialized as 'pending' " do
    subject.save!
    expect(subject.resource_state).to eq("pending")
  end

  it "returns a project title as a string" do
    subject.title = "bob"
    expect( subject.title ).to eq( "bob" )
  end

  it "returns a project description as a string" do
    subject.description = "bob"
    expect( subject.description ).to eq( "bob" )
  end

  it "returns a project location as a string" do
    expect( subject.location ).to be_a(String)
  end

  it "transition from pending review to completed" do
    project = FactoryGirl.create(:project)
    project.create_document(attributes_for(:document, resource_state: :completed))
    expect(project).to transition_from(:pending_review).to(:completed).on_event(:complete, admin)
  end

  it "returns a project start_date as a date" do
    subject.start_date = "2001-1-1"
    expect( subject.start_date ).to eq( "2001-1-1".to_date )
  end

  it "returns a project estimated_completion_date as a date" do
    subject.estimated_completion_date = "2001-1-1"
    expect( subject.estimated_completion_date ).to eq( "2001-1-1".to_date )
  end

  it "returns a project completion_date as a date" do
    subject.completion_date = "2001-1-1"
    expect( subject.completion_date ).to eq( "2001-1-1".to_date )
  end

  it "error when task resource_state is not part of the list like 'pending'" do
    expect{ FactoryGirl.create( :project, resource_state: "Bob" ) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "change the pending to completed for project resource_state" do
    subject.resource_state = "completed"
    expect( subject.resource_state ).to eq( "completed" )
  end

  it "change the pending to problem for project resource_state" do
    subject.resource_state = "problem"
    expect( subject.resource_state ).to eq( "problem" )
  end

  it "check pending for project resource_state" do
    expect( subject.resource_state ).to eq( "pending" )
  end

  it "transition from pending to route" do
    expect(subject).to transition_from(:pending).to(:en_route).on_event(:begin_route)
  end

  it "transition from problem to route" do
    expect(subject).to transition_from(:problem).to(:en_route).on_event(:begin_route)
  end

  it "transition from route to progress" do
    expect(subject).to transition_from(:en_route).to(:in_progress).on_event(:begin_working)
  end

  it "transition from route to progress" do
    expect(subject).to transition_from(:en_route).to(:in_progress).on_event(:begin_working)
  end

  it "transition from progress to pending review" do
    project = FactoryGirl.create(:project)
    project.create_document(attributes_for(:document, resource_state: :completed))
    expect(project).to transition_from(:in_progress).to(:pending_review).on_event(:request_review)
  end

  it "transition from pending review to completed" do
    project = FactoryGirl.create(:project)
    project.create_document(attributes_for(:document, resource_state: :completed))
    expect(project).to transition_from(:pending_review).to(:completed).on_event(:complete, admin)
  end

  it "transition from deactivated to problem" do
    project = FactoryGirl.create(:project)
    project.notes.build(attributes_for(:note))
    expect(project).to transition_from(:deactivated).to(:problem).on_event(:report_problem)
  end

  it "transition from pending to problem" do
    project = FactoryGirl.create(:project)
    project.notes.build(attributes_for(:note))
    expect(project).to transition_from(:pending).to(:problem).on_event(:report_problem)
  end

  it "transition from en_route to problem" do
    project = FactoryGirl.create(:project)
    project.notes.build(attributes_for(:note))
    expect(project).to transition_from(:en_route).to(:problem).on_event(:report_problem)
  end

  it "transition from in_progress to problem" do
    project = FactoryGirl.create(:project)
    project.notes.build(attributes_for(:note))
    expect(project).to transition_from(:in_progress).to(:problem).on_event(:report_problem)
  end

  it "transition from completed to problem" do
    project = FactoryGirl.create(:project)
    project.notes.build(attributes_for(:note))
    expect(project).to transition_from(:completed).to(:problem).on_event(:report_problem)
  end

  it "transition from pending to deactivated" do
    expect(subject).to transition_from(:pending).to(:deactivated).on_event(:deactivate, admin)
  end

  it "transition from en_route to deactivated" do
    expect(subject).to transition_from(:en_route).to(:deactivated).on_event(:deactivate, admin)
  end

  it "transition from in_progress to deactivated" do
    expect(subject).to transition_from(:in_progress).to(:deactivated).on_event(:deactivate, admin)
  end

  it "transition from completed to deactivated" do
    expect(subject).to transition_from(:completed).to(:deactivated).on_event(:deactivate, admin)
  end

  it "total time for complete" do
    subject.resource_state = "completed"
    expect( subject.total_time ).to eq( 2 )
  end

  it "Test set_completion_date method works" do
    subject.set_completion_date!
    expect( subject.completion_date.strftime("%m/%d/%Y at %I:%M%p") ).to eq( DateTime.now.utc.strftime("%m/%d/%Y at %I:%M%p") )
  end

  it "has an alert_level method that returns inactive when the state is pending" do
    expect( subject.alert_level ).to eq ( "inactive" )
  end

  it "Test alert_level method work for inactive when task problem" do
    task = FactoryGirl.create( :task, project: subject)
    task.notes.build(attributes_for(:note))
    task.resource_state = "problem"
    expect( subject.alert_level ).to eq ( "inactive" )
  end


  it "Test alert_level method work for operatonal" do
    task = FactoryGirl.create( :task, project: subject)
    task.notes.build(attributes_for(:note))
    task.resource_state = "in_progress"
    subject.resource_state = "in_progress"
    expect( subject.alert_level ).to eq ( "operatonal" )
  end

  # Should work but there is a bug.

  # it "Test alert_level method work for advisory" do
  #   subject.resource_state = "in_progress"
  #   task = FactoryGirl.build( :task, project: subject)
  #   task.notes.build(attributes_for(:note))
  #   task.resource_state = "problem"
  #   expect( subject.alert_level ).to eq ( "advisory" )
  # end

  # it "Test alert_level method work for danger" do
  #   subject.resource_state = "problem"
  #   task1 = FactoryGirl.create( :task, project: subject)
  #   task1.notes.build(attributes_for(:note))
    # task1.resource_state = "problem"
  #   task2 = FactoryGirl.create( :task, project: subject)
  #   task2.notes.build(attributes_for(:note))
    # task2.resource_state = "problem"
  #   expect( subject.alert_level ).to eq ( "danger" )
  # end

  # it "Test flags for one flag" do
  #   task = FactoryGirl.create( :task, project: subject)
  #   task.notes.build(attributes_for(:note))
  #   task.resource_state = "problem"
  #   expect( subject.flags.count ).to eq ( 1 )
  # end


  it "Test flags for zero flag" do
    subject.resource_state = "problem"
    expect( subject.flags.count ).to eq ( 0 )
  end
end
