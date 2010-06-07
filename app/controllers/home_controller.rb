class HomeController < ApplicationController
  def index
    @items = ItemList.enumerator(20)
  end
end
