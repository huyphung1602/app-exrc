class CommunesController < ApplicationController
  def index
    respond_to do |format|
      format.html { head(:not_acceptable) }
      format.json { render json: Commune.all }
    end
  end

  def create
    api_respond_forbidden
  end

  def show
    return api_respond_not_found if commune.nil?

    commune_decorator = CommuneDecorator.new(commune)
    api_respond_success(CommuneRepresenter.prepare(commune_decorator))
  end

  private

  def commune
    Commune.find_by(code_insee: params[:id])
  end
end
