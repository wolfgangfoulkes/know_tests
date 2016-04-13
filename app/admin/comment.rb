ActiveAdmin.register Comment, as: "UserComment" do

	actions :all, except: [:create, :edit] #should we allow creation?

# A common way to increase page performance is to elimate N+1 queries by eager loading associations:
	includes :user, :commentable#, :tags

	filter :user_name, as: :string
	filter :commentable, as: :select, collection: proc { Event.where(id: Comment.select(:commentable_id)) }

	config.sort_order = "created_at_desc"
	config.per_page = 30

	index do
		selectable_column
		column :created_at
		column "Event", :commentable
		column :comment
		column :user
		actions
	end

	show do
		attributes_table do
    		row :created_at
    		row :comment
    		row :role
    		row :public
			row :commentable
			row :root
			row :user
    	end
	end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
