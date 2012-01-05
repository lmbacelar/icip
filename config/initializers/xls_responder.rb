ActionController::Renderers.add :xls do |xls, options|

  xls = Array(xls) unless xls.is_a? Array

  timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
  filename  = options[:filename] || (xls.size == 1 ?
                                          xls.first.to_param :
                                          xls.first.class.to_s.pluralize.underscore)
  headers.merge!(
    'Cache-Control' => 'must-revalidate, post-check=0, pre-check=0',
    'Content-Disposition' => "attachment; filename=\"#{timestamp}-#{filename}.xls\"",
    'Content-Transfer-Encoding' => 'binary'
  )
  self.content_type ||= Mime::XLS
  self.response_body  = xls.respond_to?(:to_xls) ? xls.to_xls(except: [:created_at, :updated_at]) : xls
end
