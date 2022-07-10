class PeopleController < ApplicationController
  def index
    render json: Person.includes(:affiliations, :locations).all
  end

  def import
    result = PeopleServices::ImportData.call(csv_file: params[:file])

    render json: result
  end
end
