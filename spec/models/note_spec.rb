require 'rails_helper'

describe Note do

subject { FactoryGirl.create(:task) }

  it"has a valid factory" do
    expect( subject.notes.create(attributes_for(:note))).to be_valid
  end
end
