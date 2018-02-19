class AllowanceMigration < ActiveRecord::Migration[5.1]
	def change

		create_table :allowances do |t|
			t.references	:user
			t.integer 		:amount
			t.integer 		:current_balance, default: 0
			t.string		:interval_unit, default: 'week' # 'month' #day
			t.integer		:interval_value, default: 1
			t.text 			:description
			t.datetime 		:last_processed_at
			t.integer 		:status, default: 1
			t.timestamps
		end

		create_table :allowance_transactions do |t|
			t.references 	:allowance
			t.integer 		:amount
			t.integer 		:balance
			t.string		:title
			t.text 			:notes
			t.timestamps
		end
		
	end
end
