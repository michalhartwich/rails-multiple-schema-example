class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :set_user_schema

  def set_user_schema
    if current_user.present?
      PgTools.set_search_path current_user.id
    else
      PgTools.restore_default_search_path
    end
  end
end
