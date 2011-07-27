Factory.define :manager do |manager|
  manager.name  "Kevin Loken"
  manager.email "kevinloken@stonesanctuaryinteractive.com"
  manager.password  "password"
  manager.password_confirmation "password"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
