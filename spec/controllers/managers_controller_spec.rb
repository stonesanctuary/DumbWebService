require 'spec_helper'

describe ManagersController do
  render_views
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @manager = Factory(:manager)
    end
    
    it "should be successful" do
      get :show, :id => @manager
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @manager
      assigns(:manager).should == @manager
    end
    
    it "should have the right title" do
      get :show, :id => @manager
      response.should have_selector("title", :content => @manager.name)
    end
    
    it "should include the user's name" do
      get :show, :id => @manager
      response.should have_selector("h1", :content => @manager.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @manager
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
      end
      
      it "should not create a user" do
        lambda do
          post :create, :manager => @attr
        end.should_not change(Manager, :count)
      end
      
      it "should have the right title" do
        post :create, :manager => @attr
        response.should have_selector("title", :content => "Sign up")
      end
      
      it "should render the 'new' page" do
        post :create, :manager => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = {:name => "new User", :email => "user@example.org", :password => "foobar", :password_confirmation=>"foobar"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :manager => @attr
        end.should change(Manager, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :manager => @attr
        response.should redirect_to(manager_path(assigns(:manager)))
      end
      
      it "should have a welcome message" do
        post :create, :manager => @attr
        flash[:success].should =~ /welcome to fizzbits/i
      end
    end
  end
end
