module ApplicationHelper
  def icon_to(text, url, args = {})
    link_to(nil, url, args.merge(class: text.downcase, title: text.capitalize, alt: text.capitalize))
  end
end
