json.extract! member, :id, :name, :last_fee_date, :next_fee_date, :status, :amount, :created_at, :updated_at
json.url member_url(member, format: :json)