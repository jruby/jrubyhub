class ItemsController < ApplicationController
  def index
    @items = ItemList.enumerator
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    Item.create(params[:item])
    flash[:notice] = "Thanks, we added your item!"
    redirect_to :items
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
