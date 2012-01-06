module ApplicationHelper
  def icon_to(text, url, args = {})
    link_to(nil, url, args.merge(class: text.downcase, title: text.capitalize, alt: text.capitalize))
  end

  def links_to_export(args = {})
    mimes = controller.mimes_for_action(action_name)
    output = []
    mimes.delete(:html)
    mimes.each { |k,v| output << link_to(k.to_s.upcase, params.merge(format: k)) }
    content_tag :div, output.join(args[:separator]).html_safe, class: (args[:class] || 'links_to_export')
  end

  def show_hide_links
    content_tag :div, class: 'icons' do
      (icon_to('Up', '') + icon_to('Down', '')).html_safe
    end
  end
end
