
class Allowance < ApplicationRecord

	enum status: { 'inactive' => -1, 'hold' => 0, 'active' => 1 }

	belongs_to 	:user
	has_many 	:allowance_transactions


end