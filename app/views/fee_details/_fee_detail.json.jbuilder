json.extract! fee_detail, :id, :member_id, :fee_amount, :pending_fee, :fee_paid, :created_at, :updated_at
json.url fee_detail_url(fee_detail, format: :json)