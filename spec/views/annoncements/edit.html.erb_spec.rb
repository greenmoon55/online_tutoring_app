require 'spec_helper'

describe "annoncements/edit" do
  before(:each) do
    @annoncement = assign(:annoncement, stub_model(Annoncement,
      :title => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit annoncement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => annoncements_path(@annoncement), :method => "post" do
      assert_select "input#annoncement_title", :name => "annoncement[title]"
      assert_select "textarea#annoncement_content", :name => "annoncement[content]"
    end
  end
end
