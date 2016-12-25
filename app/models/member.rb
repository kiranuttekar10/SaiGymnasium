class Member < ApplicationRecord
    
    
    enum status: [:Unpaid ,:Paid, :Partial]
    
def self.search(search)
    where('name LIKE ?',"%#{search}%")
end
end
