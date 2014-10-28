class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale

  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end

  private

  def extract_locale_from_accept_language_header
    (request.env['HTTP_ACCEPT_LANGUAGE'] || 'en ').scan(/^[a-z]{2}/).first.to_sym
  end

  def supported_languages
    @supported_languages = [:de, :en, :pl, :fr, :it, :nl]
  end
end
