class InspectionsController < ApplicationController
  def index
    @inspections = Inspection.scoped
  end
end
