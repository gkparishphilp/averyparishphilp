
class AllowanceTransactionPolicy < ApplicationPolicy
	
	def admin?
		user.momdad?
	end

	def admin_create?
		user.momdad?
	end

	def admin_destroy?
		user.momdad?
	end

	def admin_edit?
		user.momdad?
	end

	def admin_update?
		user.momdad?
	end
end
