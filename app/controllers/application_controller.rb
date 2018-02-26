class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper SwellMedia::Engine.helpers

	before_action :set_page_meta

	around_action :set_timezone, if: :current_user


	def after_sign_in_path_for(resource)
		if ( oauth_uri = session.delete(:oauth_uri) ).present?
			return oauth_uri
		elsif resource.admin?
			return '/admin'
		else
			return '/'
		end
	end


	private
		def set_timezone( &block )
			Time.use_zone( current_user.timezone, &block )
		end

end