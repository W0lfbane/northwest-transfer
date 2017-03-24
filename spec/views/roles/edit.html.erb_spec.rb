require 'rails_helper'

RSpec.describe "roles/edit", type: :view do
  before(:each) do
    @role = assign(:role, Role.create!(
      :name => "MyString",
      :resource_type => "MyString",
      :resource_id => "MyString"
    ))
  end

  it "renders the edit role form" do
    render

    assert_select "form[action=?][method=?]", role_path(@role), "post" do

      assert_select "input#role_name[name=?]", "role[name]"

      assert_select "input#role_resource_type[name=?]", "role[resource_type]"

      assert_select "input#role_resource_id[name=?]", "role[resource_id]"
    end
  end
end
