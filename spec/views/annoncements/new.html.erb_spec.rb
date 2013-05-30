require 'spec_helper'

describe "annoncements/new" do
  before(:each) do
    assign(:annoncement, stub_model(Annoncement,
      :title => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new annoncement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => annoncements_path, :method => "post" do
      assert_select "input#annoncement_title", :name => "annoncement[title]"
      assert_select "textarea#annoncement_content", :name => "annoncement[content]"
    end
  end
end
