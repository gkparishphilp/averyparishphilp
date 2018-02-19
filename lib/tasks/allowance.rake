namespace :allowance do
	task weekly: :environment do
		Allowance.active.where( interval_unit: 'week' ).each do |allowance|
			allowance.allowance_transactions.create amount: 1000, title: 'Weekly Allowance'
		end
	end
end