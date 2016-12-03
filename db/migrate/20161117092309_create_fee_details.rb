class CreateFeeDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :fee_details do |t|
      t.integer :member_id
      t.date :fee_date
      t.integer :fee_amount
      t.integer :pending_fee
      t.integer :fee_paid

      t.timestamps
    end
  end
end
