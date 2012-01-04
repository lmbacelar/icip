ActionController::Renderers.add :csv do |csv, options|
  self.content_type ||= Mime::CSV
  csv = Array(csv) unless csv.is_a? Array
  self.response_body  = csv.respond_to?(:to_csv) ? csv.to_csv(except: [:created_at, :updated_at]) : csv
end
