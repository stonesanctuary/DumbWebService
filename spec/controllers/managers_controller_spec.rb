require 'spec_helper'

describe ManagersController do
  render_views
  
  describe "authentication of edit/update pages" do
    before(:each) do
      @manager = Factory(:manager)
    end
    
    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @manager
        response.should redirect_to(signin_path)
      end
    
      it "should deny access to 'update'" do
        put :update, :id => @manager, :manager => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in users" do
      before(:each) do
        wrong_user = Factory(:manager, :email => "wronguser@example.org")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id =>@manager
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for 'update'" do
        put :update, :id => @manager, :manager => {}
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "DELETE 'destory'" do
    before(:each) do
      @manager = Factory(:manager)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @manager
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@manager)
        delete :destroy, :id => @manager
        response.should redirect_to(root_path)
      end
    end
  
    describe "as an admin user" do
      before(:each) do
        admin = Factory(:manager, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @manager
        end.should change(Manager, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @manager
        response.should redirect_to(managers_path)
      end
    end
  end
  
  
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
  
  describe "GET 'index'" do
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for signed-in users" do
      before(:each) do
        @manager = test_sign_in(Factory(:manager))
        second = Factory(:manager, :email => "manager2@example.com")
        third = Factory(:manager, :email => "manager3@example.com")
        
        @managers = [@manager, second, third]
        30.times do
          @managers << Factory(:manager, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All managers")
      end
      
      it "should have an element for each manager" do
        get :index
        @managers[0..2].each do |manager|
          response.should have_selector("li", :content => manager.name)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/managers?page=2", :content => "2")
        response.should have_selector("a", :href => "/managers?page=2", :content => "Next")
      end
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
      
      it "should sign the user in" do
        post :create, :manager => @attr
        controller.should be_signed_in
      end
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @manager = Factory(:manager)
      test_sign_in(@manager)
    end
    
    describe "failure" do
      before(:each) do 
        @attr = { :email => "", :name => "", :password => "", :password_confirmation => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @manager, :manager => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @manager, :manager => @attr
        response.should have_selector("title", :content => "Edit Manager")
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "New Name", :email => "example@example.org", 
          :password => "password", :password_confirmation => "password"}
      end
      
      it "should change the user's attributes" do
        put :update, :id => @manager, :manager => @attr
        @manager.reload
        @manager.name.should == @attr[:name]
        @manager.email.should == @attr[:email]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @manager, :manager => @attr
        response.should redirect_to(manager_path(@manager))
      end
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @manager = Factory(:manager)
      test_sign_in(@manager)
    end
    
    it "should be successful" do
      get :edit, :id => @manager
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @manager
      response.should have_selector("title", :content => "Edit Manager")
    end
    
    it "should ahve a link to change the Gravatar" do
      get :edit, :id => @manager
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href=> gravatar_url, :content => "change")
    end
  end
  
end
