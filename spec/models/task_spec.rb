require 'rails_helper'

describe Task, type: :model do
  before :each do
    @test_project = FactoryGirl.create(:project)
  end

  subject { FactoryGirl.create(:task) }

  it "has a valid factory" do
    expect( FactoryGirl.create(:task, :project_id => @test_project.id) ).to be_valid
  end

  it "is invalid without a name" do
    subject.name = nil
    expect( subject ).not_to be_valid
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

  it "is valid without a resource_state" do
    expect( FactoryGirl.create(:task, resource_state: nil) ).to be_valid
  end

  it "error when task resource_state is not part of the list like 'pending'" do
    expect{ FactoryGirl.create( :task, resource_state: "Bob" ) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "change the pending to completed for task resource_state" do
    expect( subject ).to transition_from(:pending).to(:completed).on_event(:complete)
  end

  it "change the pending to problem for task resource_state" do
    expect( subject ).to transition_from(:pending).to(:problem).on_event(:report_problem, )
  end

  it "check initial state as pending for task resource_state" do
    expect( FactoryGirl.create(:task).resource_state ).to eq( "pending" )
  end

  it "is invalid without a project id" do
    expect{ FactoryGirl.create( :task, project: nil ) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "belongs to project" do
    assc = described_class.reflect_on_association(:project)
    expect( assc.macro ).to eq :belongs_to
  end
end
