class ItemsController < ApplicationController
  before_action :login_check, {only: [:new, :create]}

  before_action :set_item, {only: [:edit, :update, :destroy, :show]}

  
  def index
    @items = Item.includes(:images).limit(10).order('created_at DESC')
  end

  def new
    @item = Item.new
    @item.images.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(update_item_params)
      redirect_to root_path(@item)
    else
      render :edit
    end
  end
  
  def show
    @image = @item.images[0]
  end


  def destroy
    if @item.destroy
      redirect_to root_path
    else
      reder :edit
    end
  end
  
  def login_check
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  #検索/Viewのformで取得したパラメータをモデルに渡す
  def search
    @items = Item.search(params[:search])
  end

  def item_params
    params.require(:item).permit(:name, :content, :price, :status, :delivery_charge, :send_day, :size, :delivery_method, :prefecture_code, :category, :condition, images_attributes: [:image]).merge(seller_id: current_user.id)
  end

  def update_item_params
    params.require(:item).permit(:name, :content, :price, :status, :delivery_charge, :send_day, :size, :delivery_method, :prefecture_code, :category, :condition, images_attributes: [:image, :_destroy, :id]).merge(seller_id: current_user.id)
  end
  
  def set_item
    @item = Item.find(params[:id])
  end


end
