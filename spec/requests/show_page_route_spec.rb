require 'rails_helper'

RSpec.describe "Show Pages Route", :type => :request do
  it "assigns veriable if parameter string structured properly" do
    get root_path(resources: {projects: "Project"})
    expect(assigns(:projects).count).to eql Project.count
  end
  
  it "does not run eval/assign the variable if parameter string is structured improperly" do
    orig_count = Project.count
    get root_path(resources: {projects: "Project.create(title: 'test', description: 'test', address: '1 test st', city: 'test town', state: 'test', postal: 'test', country: 'us', start_date: DateTime.now, estimated_completion_date: DateTime.now)"})
    expect(assigns(:projects)).to be_nil
    expect(Project.count).to eql orig_count
  end
end