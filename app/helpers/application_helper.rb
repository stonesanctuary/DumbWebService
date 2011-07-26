module ApplicationHelper
  def logo
    	#<%= 
    	image_tag("logo.png", :alt => "FizzBits", :class => "round") 
    	#%>
  end
  
  def title
    base_title = "FizzBits"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
