class FeeDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fee_detail, only: [:show, :edit, :update, :destroy]

  # GET /fee_details
  # GET /fee_details.json
  def index
    @fee_details = FeeDetail.all
  end

  # GET /fee_details/1
  # GET /fee_details/1.json
  def show
  end

  # GET /fee_details/new
  def new
    @member = Member.find(params[:id])
    @fee_detail = FeeDetail.new
    @fee_detail.member_id = @member.id 
  end

  # GET /fee_details/1/edit
  def edit
  end

  # POST /fee_details
  # POST /fee_details.json
  def create
    @fee_detail = FeeDetail.new(fee_detail_params)
    attributes = fee_detail_params.clone
    member_id = attributes[:member_id]
    @member = Member.find(member_id)
    

    respond_to do |format|
      if @fee_detail.save
        if @fee_detail.fee_amount == @fee_detail.fee_paid
        @member.Paid!
        end
        if @member.admission_date < 1.month.ago 
          if @fee_detail.fee_amount == 400
            @member.last_fee_date = @member.next_fee_date
            @member.next_fee_date = @member.next_fee_date + 1.month
          elsif @fee_detail.fee_amount == 1000
            @member.last_fee_date = @member.next_fee_date
            @member.next_fee_date = @member.next_fee_date + 3.month
          else
          end
          
        end
        @member.save
        format.html { redirect_to @fee_detail, notice: 'Fee detail was successfully created.' }
        format.json { render :show, status: :created, location: @fee_detail }
      else
        format.html { render :new }
        format.json { render json: @fee_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fee_details/1
  # PATCH/PUT /fee_details/1.json
  def update
    respond_to do |format|
      if @fee_detail.update(fee_detail_params)
        @member= Member.find(@fee_detail.member_id)
        if @fee_detail.fee_amount == @fee_detail.fee_paid
        @member.Paid!
        end
        format.html { redirect_to @fee_detail, notice: 'Fee detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @fee_detail }
      else
        format.html { render :edit }
        format.json { render json: @fee_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fee_details/1
  # DELETE /fee_details/1.json
  def destroy
    @fee_detail.destroy
    respond_to do |format|
      format.html { redirect_to fee_details_url, notice: 'Fee detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fee_detail
      @fee_detail = FeeDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fee_detail_params
      params.require(:fee_detail).permit(:member_id,:fee_date, :fee_amount, :pending_fee, :fee_paid)
    end
end
