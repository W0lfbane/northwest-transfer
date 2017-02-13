require 'rails_helper'

RSpec.describe Group, type: :model do
    subject { FactoryGirl.build(described_class.name.downcase.to_sym) }
    
    describe "Validations" do
      it "is valid with valid attributes" do
        expect( subject ).to be_valid
      end
      
      it "is not valid without a name" do
        subject.name = nil
        expect( subject ).to_not be_valid    
      end
  
      it "is valid without a description" do
        subject.description = nil
        expect( subject ).to be_valid    
      end
    end

    describe "Associations" do
      it "has many users" do
        expect( described_class.reflect_on_association(:users).macro ).to eq :has_many
      end
  
      it "has many projects" do
        expect( described_class.reflect_on_association(:projects).macro ).to eq :has_many
      end
    end
    
    describe "Return Values" do
      it "returns a group name as a string" do
        subject.name = 'Bob'
        expect( subject.name ).to eq( 'Bob' )
      end

      it "returns a group description as a string" do
        subject.description = 'Test'
        expect( subject.description ).to eq( 'Test' )
      end
    end
end
