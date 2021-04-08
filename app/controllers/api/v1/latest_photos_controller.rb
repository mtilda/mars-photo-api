class Api::V1::LatestPhotosController < ApplicationController

  def index
    @rover = Rover.find_by name: params[:rover_id].titleize
    if @rover
      photos = helpers.search_photos @rover, photo_params
      photos = helpers.resize_photos photos, params

      if photos != 'size error'
        render json: photos, each_serializer: PhotoSerializer, root: :latest_photos
      else
        render json: { errors: "Invalid size parameter '#{photo_params[:size]}' for #{@rover.name.titleize} photos" }, status: :bad_request
      end
    else
      render json: { errors: "Invalid Rover Name" }, status: :bad_request
    end
  end

  private

  def photo_params
    params.permit(:camera, :earth_date, :size).merge(sol: @rover.photos.maximum(:sol))
  end
end
