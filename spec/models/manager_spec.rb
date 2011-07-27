require 'spec_helper'

describe Manager do
  
  before(:each) do
    @attr = { :name => "Example Manager", 
              :email => "manager@example.com",
              :password => "password",
              :password_confirmation => "password"
              }
  end
  
  it "should create a new instance given valid attributes" do
    Manager.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = Manager.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = Manager.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = Manager.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = Manager.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = Manager.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    Manager.create!(@attr)
    user_with_duplicate_email = Manager.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    Manager.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = Manager.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "admin attribute" do
    before(:each) do
      @manager = Manager.create!(@attr)
    end
    
    it "should respond to admin" do
      @manager.should respond_to(:admin)
    end
    
    it "should not be an admin be default" do
      @manager.should_not be_admin
    end
    
    it "should be convertable to an admin" do
      @manager.toggle!(:admin)
      @manager.should be_admin
    end
  end
  
  describe "password validations" do
    it "should require a password" do
      Manager.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      Manager.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      Manager.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      Manager.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @manager = Manager.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @manager.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @manager.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      it "should be true if the passwords match" do
        @manager.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @manager.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = Manager.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistent_user = Manager.authenticate("Bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      
      it "should return the user on email/password match" do
        matching_user = Manager.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @manager
      end
    end
  end
end
