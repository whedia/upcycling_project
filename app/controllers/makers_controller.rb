class MakersController < ApplicationController
  def new
    @user = current_user
  end

  def create
    p params[:operation]

    case operation
    when create
      maker = Maker.new(user: current_user, description: maker_permitted_params[:description], email_pro: maker_permitted_params[:email_pro],website: maker_permitted_params[:website])
      maker_address = Address.new(first_name: maker_permitted_params[:first_name], last_name: maker_permitted_params[:last_name], street_number: maker_permitted_params[:street_number], address_line_1: maker_permitted_params[:address_line_1], zip_code: maker_permitted_params[:zip_code], city: maker_permitted_params[:city], maker: maker)

      if maker.save && maker_address.save
        UserMailer.become_maker_email_admin(maker_permitted_params).deliver_now
        flash[:success] = "Votre email a bien été envoyé. Un mail de confirmation vous a été envoyé."
        redirect_to edit_user_registration_path
      else
        flash[:alert] = "Un problème est survenu, veuillez réessayer plus tard."
        redirect_to edit_user_registration_path
      end
    when validate
      puts "-" * 30
      puts "yeah"
      puts "-" * 30
      redirect_to root_path

    end
  end

  def new_maker_email
    puts "-" * 30
    puts "new_maker_email"
    puts "-" * 30
    UserMailer.become_maker_email_admin(maker_permitted_params).deliver_now
  end

  def validate_maker
    @maker = User.find_by(id: params[:maker_id]).maker
    puts "-" * 30
    p @maker
    puts "-" * 30
  end

  private

  def maker_permitted_params
    params.permit(:user_id, :first_name, :last_name, :address_line_1, :address_line_2, :street_number, :zip_code, :city, :website, :description, :email_pro)
  end

end
