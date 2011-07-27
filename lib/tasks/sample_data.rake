
namespace :db do
  desc "Add in Kevin as an admin"
  task :admin => :environment do
    kevin = Manager.find_by_email("kevinloken@stonesanctuaryinteractive.com")
    if kevin.nil?
      kevin = Manager.create!(:name => "Kevin Loken", :email => "kevinloken@stonesanctuaryinteractive.com",
      :password => "password", :password_confirmation => "password")
      kevin.toggle!(:admin)
    else
      if !kevin.admin?
        kevin.toggle!(:admin)
      end
    end
  end
end
