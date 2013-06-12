# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # get static_pages_index_path
      #response.status.should be(200)
      visit root_path
      page.should have_content("良师")
    end
  end
end
