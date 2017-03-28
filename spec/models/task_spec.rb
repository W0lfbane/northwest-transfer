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
    subject.description = nil
    expect( subject ).to be_valid
  end

  it "returns a task description as a string" do
    subject.description = "Bob"
    expect( subject.description ).to eq( "Bob" )
  end

  it "is valid without a resource_state" do
    subject.resource_state = nil
    expect( subject ).to be_valid
  end

  it "check for valid resource_state" do
    expect{ FactoryGirl.create( :task, resource_state: "Bob" ) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "change the pending to completed for task resource_state" do
    expect( subject ).to transition_from(:pending).to(:completed).on_event(:complete)
  end

  it "change the pending to problem for task resource_state" do
    subject.notes.build(attributes_for(:note))
    expect( subject ).to transition_from(:pending).to(:problem).on_event(:report_problem, @note)
  end

  it "check initial state as pending for task resource_state" do
    expect( subject.resource_state ).to eq( "pending" )
  end

  it "is invalid without a project id" do
    expect{ FactoryGirl.create( :task, project: nil ) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "belongs to project" do
    assc = described_class.reflect_on_association(:project)
    expect( assc.macro ).to eq :belongs_to
  end

  it "have many notes" do
    assc = described_class.reflect_on_association(:notes)
    expect( assc.macro ).to eq :has_many
  end
end
