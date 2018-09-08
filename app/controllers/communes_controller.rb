class CommunesController < ApplicationController
  # The tests are good. But in the real life we should use schema validator, don't we?

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

  def update
    return api_respond_not_found if commune.nil?
    return api_respond_bad_request if params[:commune].nil?

    commune.update_content!(params[:id], params[:commune][:name])
    api_respond_no_content
  end

  private

  def commune
    Commune.find_by(code_insee: params[:id])
  end
end
