class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :name ,index: true
      t.date :admission_date
      t.date :last_fee_date
      t.date :next_fee_date
      t.integer :status,null: false ,default: 0
      t.integer :amount,null: false , default: 0

      t.timestamps
    end
  end
end
