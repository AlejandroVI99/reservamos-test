class Api::V1::DestinationsController < ApplicationController
  before_action :validate_city_param, only: [ :index ]

  def index
    @destinations = DestinationService.get_destination(params[:city])
    render json: @destinations
  end

  private

  def validate_city_param
    render json: { error: 'City parameter is required' }, status: :bad_request unless params[:city].present?
  end
end
