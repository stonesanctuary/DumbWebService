require 'spec_helper'

describe Manager do
  
  before(:each) do
    @attr = { :name => "Example Manager", :email => "manager@example.com" }
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
end
