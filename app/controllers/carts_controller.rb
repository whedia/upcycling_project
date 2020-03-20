class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:update, :show]
  def create
    @user = current_user
    user_cart = Cart.create(customer: @user.customer)
  end

  def show
    @cart = Cart.find_by(id: params[:id])
  end

  def update
    @cart = current_user.customer.cart
    case params[:operation]
    when "add"
      @cart.add_item(params[:item_id])
      flash[:sucess] = "L'objet' a été ajouté au panier."
      redirect_back(fallback_location: root_path)
    when "remove"
      @cart.remove_item(params[:item_id])
      flash[:sucess] = "L'objet a été supprimé du panier."
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = "L'opération n'existe pas."
      redirect_back(fallback_location: root_path)
    end
  end
end