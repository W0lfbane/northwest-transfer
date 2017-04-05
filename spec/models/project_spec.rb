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

  it "state of the project is initialized as 'pending'" do
    subject.save!
    expect(subject.resource_state).to eq("pending")
  end

  it "returns a project title as a string" do
    expect( subject.title ).to be_a(String)
  end

  it "returns a project description as a string" do
    expect( subject.description ).to be_a(String)
  end

  it "returns a project location as a string" do
    expect( subject.location ).to be_a(String)
  end

  it "returns a project start_date as a date" do
    expect( subject.start_date ).to be_a(ActiveSupport::TimeWithZone)
  end

  it "returns a project estimated_completion_date as a date" do
    expect( subject.estimated_completion_date ).to be_a(ActiveSupport::TimeWithZone)
  end

  it "returns a project completion_date as a date" do
    expect( subject.completion_date ).to be_a(ActiveSupport::TimeWithZone)
  end

  it "error when task resource_state value is not defined in STATES" do
    expect{ FactoryGirl.create( :project, resource_state: "Bob" ) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "returns total time for project completion on total_time method" do
    expect( subject.total_time ).to eq( 2 )
  end
  
  it "has an alert_level method that returns inactive when the state is pending" do
    expect( subject.resource_state ).to eq ( "pending" )
    expect( subject.alert_level ).to eq ( "inactive" )
  end

  it "sets the completion_date when set_completion_date! is invoked" do
    datetime = DateTime.now
    subject.set_completion_date! datetime
    expect( subject.completion_date ).to eq( datetime )
  end

  describe "with created project" do
    before :each do
      subject.save!
    end
    
    context "when transition requires a completed document" do
      before :each do
        subject.create_document(attributes_for(:document, resource_state: :completed))
      end
      
      it "transitions from pending review to completed" do
        expect(subject).to transition_from(:pending_review).to(:completed).on_event(:complete, admin)
      end

      it "transitions from in_progress to pending review" do
        expect(subject).to transition_from(:in_progress).to(:pending_review).on_event(:request_review)
      end
    end
    
    context "when transition requires a note to be saved with the transition" do
      before :each do
        subject.notes.build(attributes_for(:note, user_id: admin.id))
      end
      
      it "transitions from deactivated to problem" do
        expect(subject).to transition_from(:deactivated).to(:problem).on_event(:report_problem)
      end
    
      it "transitions from pending to problem" do
        expect(subject).to transition_from(:pending).to(:problem).on_event(:report_problem)
      end
    
      it "transitions from en_route to problem" do
        expect(subject).to transition_from(:en_route).to(:problem).on_event(:report_problem)
      end
    
      it "transitions from in_progress to problem" do
        expect(subject).to transition_from(:in_progress).to(:problem).on_event(:report_problem)
      end
    
      it "transitions from completed to problem" do
        expect(subject).to transition_from(:completed).to(:problem).on_event(:report_problem)
      end
    end
  
    it "transitions from pending to en_route" do
      expect(subject).to transition_from(:pending).to(:en_route).on_event(:begin_route)
    end
  
    it "transitions from en_route to progress" do
      expect(subject).to transition_from(:en_route).to(:in_progress).on_event(:begin_working)
    end

    it "transitions from pending to deactivated" do
      expect(subject).to transition_from(:pending).to(:deactivated).on_event(:deactivate, admin)
    end
  
    it "transitions from en_route to deactivated" do
      expect(subject).to transition_from(:en_route).to(:deactivated).on_event(:deactivate, admin)
    end
  
    it "transitions from in_progress to deactivated" do
      expect(subject).to transition_from(:in_progress).to(:deactivated).on_event(:deactivate, admin)
    end
  
    it "transitions from completed to deactivated" do
      expect(subject).to transition_from(:completed).to(:deactivated).on_event(:deactivate, admin)
    end

    context do
      before :each do
        subject.begin_route!
      end

      it "should return 'advisory' as the alert_level when total flag count is 1" do
        task = subject.tasks.create!( FactoryGirl.attributes_for(:task) )
        task.notes.build(attributes_for(:note, user_id: admin.id))
        task.report_problem!
        expect( subject.alert_level ).to eq ( "advisory" )
      end
    
      it "should return 'operational' as the alert_level when total flag count is 0" do
        expect( subject.alert_level ).to eq ( "operational" )
      end
  
      it "should return 'danger' for alert_level when the number of flags is 2 or greater" do
        2.times do
          task = subject.tasks.create!( FactoryGirl.attributes_for(:task) )
          task.notes.build( FactoryGirl.attributes_for(:note, user_id: admin.id) )
          task.report_problem!
        end

        expect( subject.alert_level ).to eq ( "danger" )
      end
    end
  
    it "should return the number of tasks in a problem state as the flag count" do
      2.times do
        task = subject.tasks.create!( FactoryGirl.attributes_for(:task) )
        task.notes.build( FactoryGirl.attributes_for(:note, user_id: admin.id) )
        task.report_problem!
      end

      expect( subject.flags.count ).to eq ( 2 )
    end
  
    it "should return 0 as the flag count when no tasks are in a problem state" do
      expect( subject.flags.count ).to eq ( 0 )
    end
  end
end
