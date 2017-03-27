require 'rails_helper'

RSpec.describe "roles/new", type: :view do
  before(:each) do
    assign(:role, Role.new(
      :name => "MyString",
      :resource_type => "MyString",
      :resource_id => "MyString"
    ))
  end

  it "renders new role form" do
    render

    assert_select "form[action=?][method=?]", roles_path, "post" do

      assert_select "input#role_name[name=?]", "role[name]"

      assert_select "input#role_resource_type[name=?]", "role[resource_type]"

      assert_select "input#role_resource_id[name=?]", "role[resource_id]"
    end
  end
end
