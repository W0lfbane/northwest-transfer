require 'rails_helper'

RSpec.describe "notes/new", type: :view do
  before(:each) do
    assign(:note, Note.new(
      :text => "MyText",
      :author => "MyString"
    ))
  end

  it "renders new note form" do
    render

    assert_select "form[action=?][method=?]", nested_notes_path, "post" do

      assert_select "textarea#note_text[name=?]", "note[text]"

      assert_select "input#note_author[name=?]", "note[author]"
    end
  end
end
