class AllowanceController < ApplicationController

	before_action :authenticate_user!

	layout 'admin'
	
	def index
		@allowance = Allowance.first
		
		sort_by = params[:sort_by] || 'created_at'
		sort_dir = params[:sort_dir] || 'desc'

		@transactions = @allowance.allowance_transactions.order( "#{sort_by} #{sort_dir}" )
		
		@transactions = @transactions.page( params[:page] )
	end

end