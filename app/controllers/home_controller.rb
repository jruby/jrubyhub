class HomeController < ApplicationController
  def index
    @items = ItemList.enumerator
  end
end
