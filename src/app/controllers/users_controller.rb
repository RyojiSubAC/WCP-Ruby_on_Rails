class UsersController < ApplicationController
	before_action :authenticate_user!
	# before_action :set_user, only: [:edit, :update]

	def index
		@users = User.all
		@user = current_user
		@new_book = Book.new
	end

	def show
		@user = User.find(params[:id])
		@book = @user.books
		@new_book = Book.new
	end

	def edit
		@user = User.find(params[:id])
		if @user != current_user
	    	redirect_to user_path(current_user)
	    end
	end

	def update
		@user = User.find(params[:id])
		respond_to do |format|
			if @user.update(user_params)
				format.html{redirect_to user_path(@user.id), notice: 'Profile was successfully updated.' }
			else
				format.html{render :edit}
			end
		end
	end

    private

    def user_params
        params.require(:user).permit(:name, :profile_image, :introduction)
    end

    # def set_user
    #     @user = User.find(params[:id])
    # end
end

