class AllowanceTransaction < ApplicationRecord

	belongs_to 	:allowance

	after_save 	:update_balances


	private

		def update_balances
			self.allowance.current_balance = self.allowance.current_balance + self.amount 
			self.allowance.save

			#straight update should not fire callbacks, thus preventing infinite loop here
			self.update_column( :balance, self.allowance.current_balance )
		end

end