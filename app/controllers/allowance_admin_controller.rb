
class AllowanceAdminController < ApplicationController
	layout 'admin'

	before_action 	:authenticate_user!
	before_action	:require_momdad
	before_action 	:get_transaction, only: [ :destroy, :edit, :update ]


	def create
		@transaction = Allowance.first.allowance_transactions.new( transaction_params )
		
		@transaction.amount = transaction_params[:amount].to_f * 100

		@transaction.save
		redirect_back( fallback_location: '/admin' )
	end

	def index
		@allowance = Allowance.first
		
		sort_by = params[:sort_by] || 'created_at'
		sort_dir = params[:sort_dir] || 'desc'

		@transactions = @allowance.allowance_transactions.order( "#{sort_by} #{sort_dir}" )
		
		@transactions = @transactions.page( params[:page] )

	end


	def update_allowance
		@allowance = Allowance.first
		@allowance.amount = params[:amount].to_f * 100 
		@allowance.status = params[:status]
		@allowance.save
		redirect_back( fallback_location: '/admin' )
	end


	def update
		@transaction.attributes = transaction_params
		@transaction.amount = transaction_params[:amount].to_f * 100
		@transaction.save
		redirect_back( fallback_location: '/admin' )
	end




	private

		def get_transaction
			@transaction = Allowance.first.allowance_transactions.find( params[:id] )
		end

		def transaction_params
			params.require( :allowance_transaction ).permit( :title, :amount, :notes )
		end

		def require_momdad
			unless current_user.momdad?
				redirect_to '/admin'
				return false
			end
		end

end