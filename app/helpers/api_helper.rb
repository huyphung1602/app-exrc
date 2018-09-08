module ApiHelper
  STATUS_CODES = {
    SUCCESS:           200,
    NO_CONTENT:        204,
    BAD_REQUEST:       400,
    FORBIDDEN:         403,
    NOT_FOUND:         404,
    NOT_ACCEPTABLE:    406,
  }.freeze

  STATUS_CODES.keys.each do |status|
    status_string = status.to_s.downcase

    define_method :"api_respond_#{status_string}" do |*args|
      response_hash = args[0] || {}
      web_api_respond(status, response_hash)
    end
  end

  private

  def web_api_respond(status, response_hash)
    response = { status: status }
    response = response.merge(response_hash) if response_hash
    render json: response, status: STATUS_CODES[status]
  end
end
