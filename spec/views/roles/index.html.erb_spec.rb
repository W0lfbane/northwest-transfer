require 'rails_helper'

RSpec.describe "roles/index", type: :view do
  before(:each) do
    assign(:roles, [
      Role.create!(
        :name => "Name",
        :resource_type => "Resource Type",
        :resource_id => "Resource"
      ),
      Role.create!(
        :name => "Name",
        :resource_type => "Resource Type",
        :resource_id => "Resource"
      )
    ])
  end

  it "renders a list of roles" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Resource Type".to_s, :count => 2
    assert_select "tr>td", :text => "Resource".to_s, :count => 2
  end
end
