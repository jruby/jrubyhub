class HomeController < ApplicationController
  def index
    @items = ItemList.enumerator(50)
  end
end
