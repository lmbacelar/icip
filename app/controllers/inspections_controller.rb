class InspectionsController < ApplicationController
  def index
    @inspections = Inspection.all
  end
end
