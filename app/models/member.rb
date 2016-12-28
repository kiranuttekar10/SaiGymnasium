class Member < ApplicationRecord


def self.check_validation(member)
    if member.last_fee_date != nil && member.next_fee_date
       return false
    else
        return true
    end
end   
    
    enum status: [:Unpaid ,:Paid, :Partial]
    
def self.search(search)
    where('name LIKE ?',"%#{search}%")
end
end
