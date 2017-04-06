require 'rails_helper'

RSpec.describe Helpers::ResourceStateHelper, type: :helper do
  describe "testing the methods" do

    let(:including_module)do
      Class.new do
        extend Helpers::ResourceStateHelper
        STATES = [:pending, :en_route, :in_progress, :pending_review, :completed, :problem, :deactivated]
        include AASM
      end
    end

    context "validate_state method" do
      specify {
        expect( including_module.valid_state?(:pending)).to be_truthy
      }
    end

    context "state_complete method" do
      specify {
        expect( including_module.state_completed?(:pending, :completed)).to be_truthy
      }
    end

    context "current_state method" do
      specify {
        expect( including_module.current_state?(:pending, :completed)).to be_falsy
      }
    end

    context "interacting_with_state method" do
      specify {
        expect( including_module.interacting_with_state?(:pending, :completed)).to be_truthy
      }
    end

    context "set_state_user method" do
      specify {
        expect( including_module.set_state_user(:admin))
      }
    end

    # context "transitioning_to_problem_state method" do
    #   specify {
    #     expect( including_module.transitioning_to_problem_state?).to be_truthy
    #   }
    # end
  end
end
