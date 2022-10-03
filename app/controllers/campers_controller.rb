class CampersController < ApplicationController
    wrap_parameters false
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_error
    def index
        campers = Camper.all
        render json: campers
    end

    def show
        camper = find_camper
        render json: camper, serializer: CamperWithActivitiesSerializer
    end

    def create
        campers = Camper.create!(movie_params)
        render json: campers, status: :created
    end

    private

    def find_camper
        Camper.find(params[:id])
    end

    def movie_params
        params.permit(:name, :age)
    end

    def render_not_found_response
        render json: {error: "Camper not found"}, status: :not_found
    end

    def render_error(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
