ActiveAdmin.register User do
	actions :all, except: [:create, :edit]

	filter :email, as: :string
	filter :name, as: :string

	includes :events, :comments

	index do
		selectable_column
		column :email
		column :name
		actions
	end

	show do
		tabs do 
			tab "Summary" do 
		    	attributes_table do
		    		row :email
		      		row :name
		    	end
		    end
		    tab "Events" do
		    	table_for user.events do
		    		column :created_at
		    		column :name
		    		column do |event|
		    			link_to "View", admin_event_path(event.id)
		    		end
		    		# column :comment do |comment|
		    		# 	link_to comment.comment, admin_user_comment_path(comment.id)
		    		# end
		    	end
		   	end
		    tab "Comments" do
		    	table_for user.comments do
		    		column :created_at
		    		column :comment
		    		column do |comment|
		    			link_to "View", admin_user_comment_path(comment.id)
		    		end
		    	end
		   	end	
		end
	end

end
