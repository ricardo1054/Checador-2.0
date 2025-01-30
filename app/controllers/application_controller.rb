class ApplicationController < ActionController::Base
  before_action :set_timezone
  allow_browser versions: :modern

  private

  def set_timezone
    Time.zone = 'America/Mexico_City'
  end
end
