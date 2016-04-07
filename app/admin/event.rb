ActiveAdmin.register Event do

	actions :all, except: [:create, :edit]

# A common way to increase page performance is to elimate N+1 queries by eager loading associations:
	includes :user, :comments, :tags

	filter :name, as: :string
	filter :user_name, as: :string
	filter :tags, as: :select

	config.sort_order = "created_at_desc"
	config.per_page = 30

	index do
		selectable_column
		column :created_at
		column :name
		column :user
		column "Tags", :tag_list
		actions	
	end

	show do
		tabs do 
			tab "Summary" do 
		    	attributes_table do
		    		row :created_at
		      		row :name
		      		row :user
		      		row :description
		      		row "Tags", :tag_list
		      		row :starts_at
		      		row :ends_at
		    	end
		    end
		    tab "Owner Comments" do
		    	table_for event.owner_comments do
		    		column :created_at
		    		column :comment
		    		column do |comment|
		    			link_to "View", admin_user_comment_path(comment.id)
		    		end
		    	end
		   	end
		   	tab "Community Comments" do
		    	table_for event.list_comments do
		    		column :created_at
		    		column :user
		    		column :comment
		    		column do |comment|
		    			link_to "View", admin_user_comment_path(comment.id)
		    		end
		    		# column :comment do |comment|
		    		# 	link_to comment.comment, admin_user_comment_path(comment.id)
		    		# end
		    	end
		   	end
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
