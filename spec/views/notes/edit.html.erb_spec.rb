require 'rails_helper'

RSpec.describe "notes/edit", type: :view do
  before(:each) do
    @note = assign(:note, Note.create!(
      :text => "MyText",
      :author => "MyString"
    ))
  end

  it "renders the edit note form" do
    render

    assert_select "form[action=?][method=?]", nested_note_path(@note), "post" do

      assert_select "textarea#note_text[name=?]", "note[text]"

      assert_select "input#note_author[name=?]", "note[author]"
    end
  end
end
