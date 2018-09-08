class ApplicationController < ActionController::Base
  include ApiHelper
  protect_from_forgery with: :exception
end
