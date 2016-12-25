class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /members
  # GET /members.json
  def index
    if params[:search]
      @members = Member.search(params[:search])
    else  
      @members = Member.all
      @members.each do |member|
        
          if member.next_fee_date < Date.today 
          
           member.Unpaid!
          
          else
           member.Paid!
          end
        
      end
    end
  end
  
  def autocomplete
    @members = Member.order(:name).where('lower(name) LIKE ?',"%#{params[:term]}%".downcase)
    respond_to do |format|
      format.html
      format.json {
        render json: @members.map(&:name).to_json
      }
    end
  end
  
  def pending_fee
    @membersall = Member.all
    @members =[ ]
    @membersall.each do |member|
      
      if member.next_fee_date < Date.today 
      
          @members << member
      end
    end
  end
  
  def upcoming_fee
    @membersall =Member.all
    @members = []
    @membersall.each do |member|
      if member.next_fee_date < (Date.today + 4.days) && member.Paid!
        @members << member
      end
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    
      if @member.next_fee_date < Date.today 
        
          @member.Unpaid!
      else
         @member.Paid!
      end
    
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end
  

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)
    if @member.amount == 500
      @member.last_fee_date = @member.admission_date
      @member.next_fee_date = @member.admission_date + 31.days
    elsif @member.amount == 1100
      @member.last_fee_date = @member.admission_date
      @member.next_fee_date = @member.admission_date + 3.month
    elsif @member.amount == 400
      @member.last_fee_date = @member.next_fee_date
      @member.next_fee_date = @member.next_fee_date + 31.days
    else
      @member.last_fee_date = @member.next_fee_date
      @member.next_fee_date = @member.next_fee_date + 3.month
    end
    
    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:name, :admission_date, :status, :amount)
    end
end
