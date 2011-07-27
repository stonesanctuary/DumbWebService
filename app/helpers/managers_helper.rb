module ManagersHelper
  def gravatar_for(manager, options = { :size => 50 })
    gravatar_image_tag(manager.email.downcase, :alt => manager.name, :class => 'gravatar', :gravatar => options)
  end
end
