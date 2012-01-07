module ApplicationHelper
  def icon_to(text, url, args = {})
    link_to(nil, url, args.merge(class: text.downcase, title: text.capitalize, alt: text.capitalize))
  end

  def export_links(args = {})
    mimes = controller.mimes_for_action(action_name)
    output = []
    mimes.delete(:html)
    mimes.each { |k,v| output << link_to(k.to_s.upcase, params.merge(format: k)) }
    content_tag :div, output.join(args[:separator]).html_safe, class: (args[:class] || 'export_links')
  end

  def show_hide_links
    content_tag :div, class: 'icons' do
      (icon_to('Up', '') + icon_to('Down', '')).html_safe
    end
  end

  def group_tag(args = {}, &block)
    html= content_tag :div, class: 'group' do
      if args[:title]
        html = content_tag :div, class: 'title' do
          html = show_hide_links unless args[:show_hide_links]
          html += args[:title]
          if args[:export_links]
            if args[:export_links].is_a? Hash
              html += export_links separator: args[:export_links][:separator]
            else
              html += export_links
            end
          end
          html
        end
        html
      end
      html += content_tag :div, class: (args[:content_class] || 'content') do
        yield block
      end
    end
    html.html_safe
  end
end
