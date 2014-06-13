class ContactItemsController < ApplicationController
  before_action :set_contact_item, only: [:show, :edit, :update, :destroy]

  # GET /contact_items
  # GET /contact_items.json
  def index
    @contact_items = ContactItem.all
  end

  # GET /contact_items/1
  # GET /contact_items/1.json
  def show
  end

  # GET /contact_items/new
  def new
    @contact_item = ContactItem.new
  end

  # GET /contact_items/1/edit
  def edit
  end

  # POST /contact_items
  # POST /contact_items.json
  def create
    @contact_item = ContactItem.new(contact_item_params)

    respond_to do |format|
      if @contact_item.save
        format.html { redirect_to @contact_item, notice: 'Contact item was successfully created.' }
        format.json { render :show, status: :created, location: @contact_item }
      else
        format.html { render :new }
        format.json { render json: @contact_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_items/1
  # PATCH/PUT /contact_items/1.json
  def update
    respond_to do |format|
      if @contact_item.update(contact_item_params)
        format.html { redirect_to @contact_item, notice: 'Contact item was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact_item }
      else
        format.html { render :edit }
        format.json { render json: @contact_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_items/1
  # DELETE /contact_items/1.json
  def destroy
    @contact_item.destroy
    respond_to do |format|
      format.html { redirect_to contact_items_url }
      format.json { head :no_content }
    end
  end

  def alone
    @item = ContactItem.find(params[:id])
    @item.contact.destroy if @item.contact.contact_items.size == 1
    @contact = Contact.new(:name => @item.name, :user_id => @item.platform.user_id)
    @contact.save
    @item.contact_id = @contact.id
    @item.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_item
      @contact_item = ContactItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_item_params
      params.require(:contact_item).permit(:address, :name, :platform_id, :contact_id)
    end
end
