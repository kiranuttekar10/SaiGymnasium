class Member < ApplicationRecord
    has_many :fee_details,dependent: :destroy
    
    enum status: [:Unpaid ,:Paid, :Installment]
end
