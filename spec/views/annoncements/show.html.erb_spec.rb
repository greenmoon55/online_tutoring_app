require 'spec_helper'

describe "annoncements/show" do
  before(:each) do
    @annoncement = assign(:annoncement, stub_model(Annoncement,
      :title => "Title",
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
  end
end
