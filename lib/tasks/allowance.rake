namespace :allowance do
	task process: :environment do
		Allowance.active.each do |allowance|
			next if allowance.last_processed_at.present? && allowance.last_processed_at > eval( "#{allowance.interval_value}.#{allowance.interval_unit}.ago" ) 
			allowance.allowance_transactions.create amount: 1000, title: "Allowance for #{Time.now.strftime("%B #{Time.now.day.ordinalize}, %Y")}"
			allowance.touch( :last_processed_at )
		end
	end
end