require 'rails_helper'

RSpec.describe "roles/show", type: :view do
  before(:each) do
    @role = assign(:role, Role.create!(
      :name => "Name",
      :resource_type => "Resource Type",
      :resource_id => "Resource"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Resource Type/)
    expect(rendered).to match(/Resource/)
  end
end
