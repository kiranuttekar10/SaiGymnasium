class Member < ApplicationRecord
    has_many :fee_details,dependent: :destroy
    
    enum status: [:Unpaid ,:Paid, :Partial]
    
def self.search(search)
    where('name LIKE ?',"%#{search}%")
end
end
