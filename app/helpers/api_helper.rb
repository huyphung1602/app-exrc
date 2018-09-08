module ApiHelper
  STATUS_CODES = {
    SUCCESS:           200,
    FORBIDDEN:         403,
    NOT_FOUND:         404,
    NOT_ACCEPTABLE:    406,
  }.freeze

  def api_respond_success(response_hash = {})
    web_api_respond(:SUCCESS, response_hash)
  end

  def api_respond_forbidden(response_hash = {})
    web_api_respond(:FORBIDDEN, response_hash)
  end

  def api_respond_not_found(response_hash = {})
    web_api_respond(:NOT_FOUND, response_hash)
  end

  def api_respond_error(response_hash = {})
    web_api_respond(:NOT_ACCEPTABLE, response_hash)
  end

  private

  def web_api_respond(status, response_hash)
    response = { status: status }
    response = response.merge(response_hash) if response_hash
    render json: response, status: STATUS_CODES[status]
  end
end
