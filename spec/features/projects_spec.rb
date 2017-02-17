require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  describe "GET project/:id" do
    it "displays project info" do
      user = FactoryGirl.create(:admin)
      sign_in user
      project = FactoryGirl.create(:project)
      visit project_path(project)
      expect(page).to have_content project.title
    end
  end
end
