class GroupsController < ApplicationController

	before_action :require_login

	before_action :get_groups

	def update_previllige
		if params[:id].present? && params[:value].present? && params[:previllige]
			group = Group.find(params[:id])
			case params[:previllige]

			when 'login'
				group.can_login = true if params[:value] == 'true'
				group.can_login = false if params[:value] == 'false'
			when 'order'
				puts 'in_order'
				group.can_order = true if params[:value] == 'true'
				group.can_order = false if params[:value] == 'false'
			when 'admin'
				group.can_admin = true if params[:value] == 'true'
				group.can_admin = false if params[:value] == 'false'
			else
			end
			group.save
			@groups = Group.all.page(params[:page]).per_page(10)
			respond_to do |format|
				format.js
			end
		end
	end

	def new
		@group = Group.new
		respond_to do |format|
			format.js {render 'update_previllige'}
		end
	end

	def create
		group = Group.new(group_params);
		if group.save
			respond_to do |format|
				format.js {render 'update_previllige'}
			end
		end
	end

	def destroy
		group = Group.find(params[:id])

		if group.destroy
			respond_to do |format|
				format.js {render 'update_previllige'}
			end
		end
		
	end
	private
	def get_groups
		@groups = Group.all.page(params[:page]).per_page(10)
		
	end

	def group_params
		params.require(:group).permit(:name)
	end

end
