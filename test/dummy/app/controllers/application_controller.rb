class ApplicationController < ActionController::Base
  protect_from_forgery
  def pon_lateral

  end

  def render_404
    render text: 'Not found', status: 404
  end
end
