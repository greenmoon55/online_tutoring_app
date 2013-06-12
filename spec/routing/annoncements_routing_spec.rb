# -*- encoding : utf-8 -*-
require "spec_helper"

describe AnnoncementsController do
  describe "routing" do

    it "routes to #index" do
      get("/annoncements").should route_to("annoncements#index")
    end

    it "routes to #new" do
      get("/annoncements/new").should route_to("annoncements#new")
    end

    it "routes to #show" do
      get("/annoncements/1").should route_to("annoncements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/annoncements/1/edit").should route_to("annoncements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/annoncements").should route_to("annoncements#create")
    end

    it "routes to #update" do
      put("/annoncements/1").should route_to("annoncements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/annoncements/1").should route_to("annoncements#destroy", :id => "1")
    end

  end
end
