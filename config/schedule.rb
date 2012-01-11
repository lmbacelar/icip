# Set Cron Tasks.
# To Update crontab, run 'bundle exec whenever -i' from rails app root.
set :environment, :development
set :output, "#{path}/log/cron.log"

# Schedule inspections
every 12.hours do
  runner "Zone.order('zones.id DESC').schedule_inspections(1)"
  rake "environment tire:import CLASS='Inspection' FORCE=true"
end

# Reindex Parts and Inspections
every 1.hour do
  rake "environment tire:import CLASS='Part' FORCE=true"
  rake "environment tire:import CLASS='Inspection' FORCE=true"
  rake "environment tire:import CLASS='Tasc' FORCE=true"
end
