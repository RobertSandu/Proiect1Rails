class SessionsController < ApplicationController

  def new

  end

  def create
  	#mai intai caut userul in functie de mail, care este unic
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user

  		if user.authenticate(params[:session][:password])
  			log_in user
  			redirect_to user
  		else
  			#parola nu este valida
  			flash[:danger] = 'Parola nu este valida'
  			render 'new'
  			#format.html { redirect_to :controller => 'sessions', :action => 'new', notice: 'Parola nu este valida'}
  		end

  	else
  		#userul nu exista
  		flash[:danger] = 'Userul nu exista'
  		render 'new'
  		#format.html { redirect_to :controller => 'sessions', :action => 'new', notice: 'Userul nu exista'}
  	end

  end

  def destroy
  	log_out
  	redirect_to root_url
  end

end
