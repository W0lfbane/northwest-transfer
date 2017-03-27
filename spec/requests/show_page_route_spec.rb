require 'rails_helper'

RSpec.describe "Show Pages Route", :type => :request do
  
  describe "allowed parameter strings" do
    before :each do
       sign_in(FactoryGirl.create(:admin))
       5.times { FactoryGirl.create(:project) }
    end
    
    it "assigns veriable if parameter string is only project name" do
      get root_path(resources: {projects: "Project"})
      expect(assigns(:projects).count).to eql Project.count
    end
    
    it "allows use of limit" do
      get root_path(resources: {projects: "Project.limit(2)"})
      expect(assigns(:projects).count).to eql 2
      expect(assigns(:projects).count).to_not eql Project.count
    end
    
    it "allows use of order" do
      get root_path(resources: {projects: "Project.order(id: :desc)"})
      expect(assigns(:projects).count).to eql Project.count
      expect(assigns(:projects).first).to eql Project.last
    end
    
    it "allows use of where" do
      2.times { FactoryGirl.create(:project, title: "new") }
      get root_path(resources: {projects: "Project.where(title: 'new')"})
      expect(assigns(:projects).count).to eql 2
      expect(assigns(:projects)).to include Project.last
    end
    
    it "allows use of find" do
      get root_path(resources: {project: "Project.find(#{Project.last.id})"})
      expect(assigns(:project)).to eql Project.last
    end
    
    it "allows supported queries to be chained" do
      get root_path(resources: {projects: "Project.order(id: :desc).limit(2)"})
      expect(assigns(:projects).count).to eql 2
      expect(assigns(:projects).first).to eql Project.last
    end
  end
  
  describe "invalid parameter strings are not evaluated/assigned" do
    it "does not respond to parameters not structures as queries" do
      get root_path(resources: {projects: "give me all projects pls"})
      expect(assigns(:projects)).to be_nil
    end
    
    it "does not respond to unsupported queries" do
      orig_count = Project.count
      get root_path(resources: {projects: "Project.create(title: 'test', description: 'test', address: '1 test st', city: 'test town', state: 'test', postal: 'test', country: 'us', start_date: DateTime.now, estimated_completion_date: DateTime.now)"})
      expect(assigns(:projects)).to be_nil
      expect(Project.count).to eql orig_count
    end
    
    it "does not evaluate at all if unsupported queries are chained to supported queries" do
      get root_path(resources: {projects: "Project.order(id: :desc).take(2)"})
      expect(assigns(:projects)).to be_nil
    end
  end
end