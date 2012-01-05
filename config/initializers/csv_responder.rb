ActionController::Renderers.add :csv do |csv, options|

  csv = Array(csv) unless csv.is_a? Array

  timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
  filename  = options[:filename] || (csv.size == 1 ?
                                          csv.first.to_param :
                                          csv.first.class.to_s.pluralize.underscore)
  headers.merge!(
    'Cache-Control' => 'must-revalidate, post-check=0, pre-check=0',
    'Content-Disposition' => "attachment; filename=\"#{timestamp}-#{filename}.csv\"",
    'Content-Transfer-Encoding' => 'binary'
  )
  self.content_type ||= Mime::CSV
  self.response_body  = csv.respond_to?(:to_csv) ? csv.to_csv(except: [:created_at, :updated_at]) : csv
end
