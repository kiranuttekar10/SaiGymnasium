class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_member, only: [:show, :edit, :update, :destroy,:fee_pay,:fee_pay_regular,:fee_pay_new,:member_reset ,:reset]
  require 'will_paginate/array'
  
  
  # GET /members
  # GET /members.json
  def index
    if params[:search]
      @members = Member.search(params[:search]).paginate(:page => params[:page], :per_page => 15)
    else  
      @members = Member.all.paginate(:page => params[:page],:per_page => 15)
      @members.each do |member|
        if member.next_fee_date != nil   
          if member.next_fee_date < Date.today && member.next_fee_date > (Date.today - 1.month)
          
           member.Unpaid!
          
          elsif member.next_fee_date < (Date.today - 1.month)
           member.Inactive!
          else
           member.Paid!
          end
        else
          member.Unpaid!
        end
        
      end
    end
  end                                    #index function ends
  
  
  
  
  def autocomplete
    @members = Member.order(:name).where('lower(name) LIKE ?',"%#{params[:term]}%".downcase)
    respond_to do |format|
      format.html
      format.json {
        render json: @members.map(&:name).to_json
      }
    end
  end                               #autocomplete function completes
  
  
  
  # GET /members/pending_fee   - pending_fee_members_path
  def pending_fee
    if params[:search]
      @members = Member.search(params[:search]).paginate(:page => params[:page], :per_page => 15)
    else
    @membersall = Member.all
    @memberstotal =[ ]
    @membersall.each do |member|
      if member.next_fee_date != nil 
      if member.next_fee_date < Date.today 
      
          @memberstotal << member
      end
      else
         @memberstotal << member
      end
    end
    @members = @memberstotal.paginate(:page => params[:page], :per_page => 15)
    end
    
  end                              #end of pending_fee function
  
  
  
  # GET /members/upcoming_fee    - upcoming_fee_members_path
  def upcoming_fee
    if params[:search]
      @members = Member.search(params[:search]).paginate(:page => params[:page], :per_page => 15)
    else
    @membersall =Member.all
    @memberstotal = []
    @membersall.each do |member|
      if member.next_fee_date != nil
      if ((member.next_fee_date > Date.today && member.next_fee_date < (Date.today + 4.days)))
        @memberstotal << member
      end
      else
        @memberstotal << member
      end
    end
    @members = @memberstotal.paginate(:page => params[:page],:per_page => 15)
    end
  end                  #end of upcoming fee function
  
 
  def update_fee
    @member = Member.find(params[:id])
    attributes = update_fee_params.clone
    if attributes[:amount] == "600"
        @member.last_fee_date = @member.next_fee_date 
        @member.next_fee_date = @member.next_fee_date + 31.days
    elsif attributes[:amount] == "1500"
        @member.last_fee_date = @member.next_fee_date
        @member.next_fee_date = @member.next_fee_date + 3.month
    end
     respond_to do |format|
      #if @member.update(update_fee_params) 
      if @member.save   
        @member.Paid!
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
        format.js 
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
        format.js 
      end
    end
    
  end                 # end of update_fee

 
 
  # GET /members/1
  # GET /members/1.json
  def show
    if @member.next_fee_date != nil
      if @member.next_fee_date < Date.today && @member.next_fee_date > (Date.today - 1.month)
        
        @member.Unpaid!
      elsif @member.next_fee_date < (Date.today - 1.month) 
        @member.Inactive!
      else
        @member.Paid!
      end
    else
      @member.Unpaid!
    end
    
  end                    #show function end

  
  # GET /members/new
  def new
    @member = Member.new
  end                    # new function end

  
  # GET /members/1/edit
  def edit
  end                    #edit function end
  
  def reset
  end                    #reset function end
  
  def fee_pay
    
  end                     #fee_pay function end
  
 # def fee_pay_regular
#    attributes = fee_regular_params.clone
#    if attributes[:amount] == "400"
#      if @member.last_fee_date != nil &&  @member.next_fee_date != nil 
#      @member.last_fee_date = @member.next_fee_date
#      @member.next_fee_date = @member.next_fee_date + 31.days
#      else
#      @member.last_fee_date = Date.today
#      @member.next_fee_date = Date.today + 31.days
#      end
#    elsif attributes[:amount] == "1000"
#      if @member.last_fee_date != nil && @member.next_fee_date != nil 
#      @member.last_fee_date = @member.next_fee_date
#      @member.next_fee_date = @member.next_fee_date + 3.month
#      else
#      @member.last_fee_date = Date.today
#      @member.next_fee_date = Date.today + 3.month
#      end
#    end
#    respond_to do |format|
#      if @member.update(fee_regular_params) && @member.save
#        @member.Paid!
#        format.html { redirect_to @member, notice: "Member's fee updated successfully." }
#        format.json { render :show, status: :created, location: @member }
#      else
#        format.html { render :fee_pay }
#        flash[:alert] = "There must be some blank field which is not selected ,Please fill the form properly"        
#      end
#    end
#    
#  end
  
  
#   def fee_pay_new
#    @result=Member.check_validation(@member)
#    if @result ==true
#      attributes = fee_regular_params.clone
#      if attributes[:amount] == "600"
#       @member.last_fee_date = @member.admission_date
#        @member.next_fee_date = @member.admission_date + 31.days
#      elsif attributes[:amount] == "1500"
#        @member.last_fee_date = @member.admission_date
#        @member.next_fee_date = @member.admission_date + 3.month
#      end
#      respond_to do |format|
#        if @member.update(fee_regular_params) && @member.save
#          @member.Paid!
#          format.html { redirect_to @member, notice: "Member's fee updated successfully." }
#          format.json { render :show, status: :created, location: @member }
#        else
#          format.html { render :fee_pay }
#          flash[:alert] = "There must be some blank field which is not selected ,Please fill the form again properly"        
#        end
#      end
#    else
#      respond_to do |format|
#        format.html { redirect_to :back }
#        flash[:alert] = "This member is not new, either click on RESET button or the Regular member button and  fill the form"; 
#      end
#    end
#    
#   end
  
  
  def member_reset
     #attributes = member_reset_params.clone
     next_fee_date = Date.new(params[:member]["next_fee_date(1i)"].to_i,params[:member]["next_fee_date(2i)"].to_i,params[:member]["next_fee_date(3i)"].to_i)
  if (next_fee_date < Date.today)
  
         redirect_to(:back)
         flash[:alert] = "Please fill the form properly"
         
  else    
     respond_to do |format|
       
      if @member.update(member_reset_params) 
        format.html { redirect_to @member, notice: "Member's fee and fee dates updated successfully." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { redirect_to(request.env['HTTP_REFERER']) }
        flash[:alert] = "Please fill the form again"
      end
    end
  end
  end
 
 
  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)
    attributes = member_params.clone
      if attributes[:amount] == "600"
        @member.last_fee_date = @member.admission_date
        @member.next_fee_date = @member.admission_date + 31.days
      elsif attributes[:amount] == "1500"
        @member.last_fee_date = @member.admission_date
        @member.next_fee_date = @member.admission_date + 3.month
      end
    
    respond_to do |format|
      if @member.save
        @member.Paid!
        format.html { render :show, notice: 'Member was successfully created.' }
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
    
    def fee_regular_params
       params.require(:member).permit( :status, :amount)
    end
    
    def update_fee_params
       params.require(:member).permit(:amount)
    end
    
    def member_reset_params
      params.require(:member).permit(:last_fee_date,:next_fee_date,:amount,:status)
    end
end
