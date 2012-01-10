module ApplicationHelper
  def icon_to(text, url, args = {})
    link_to(nil, url, args.merge(class: text.downcase, title: text.capitalize, alt: text.capitalize))
  end

  def export_links(args = {})
    # Get URL for export links. If no path supplied, assume current path
    url = Rails.application.routes.recognize_path(args[:path]) if args[:path].present?
    url = Rails.application.routes.recognize_path(request.env['PATH_INFO']) if args[:path].blank?
    # Get mime types for this controller / action
    mimes = eval "#{url[:controller].to_s.capitalize}Controller.mimes_for_action(:#{url[:action].to_sym})"
    output = []
    # Generate link for each mime type the controller / action responds to other than html.
    mimes.delete(:html)
    mimes.each { |k,v| output << link_to(k.to_s.upcase, url.merge(format: k)) }
    # Return links, separated (if specified) and classed '.export_links' (or other if specified).
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
          if (args[:show_hide_links].nil? || args[:show_hide_links])
            html = show_hide_links
          else
            html = ''
          end
          html += args[:title]
          if args[:export_links]
            if args[:export_links].is_a? Hash
              html += export_links args[:export_links]
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
