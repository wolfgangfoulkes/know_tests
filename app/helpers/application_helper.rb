module ApplicationHelper
	# ----- CLASS METHODS -----
	# --- can be referenced in controller via ApplicationHelper.method
	# --- can't reference other helper methods that aren't class-methods
	# --- consider move to specific 'universal' helper
	def self.isa?(o_, class_) # -		-	-	-	-	-	-	-	-	- USED HERE
		o_.class.name == class_
	end

	def self.timestamps?(o_) # -		-	-	-	-	-	-	-	-	- USED HERE
		!(defined?(o_.created_at).nil? || defined?(o_.created_at).nil?)
	end

	def self.fresh_after?(o_, dt_) # -		-	-	-	-	-	-	-	- USED HERE
		(o_.created_at.to_f >= dt_.to_f) ||
		(o_.updated_at.to_f >= dt_.to_f)
	end

	def self.fresh_for_user?(o_, user_) # -		-	-	-	-	-	-	- USED HERE, CONTROLLER
		fresh_after?(o_, user_.last_sign_in_at)
	end

	# ----------

	# ----- HELPER METHODS -----
	# - can be referenced in view, and in model, with 'include' 
	# - non-class methods will be overriden by helpers with alphabetically later names

	# ----- from class methods
	def isa?(o_, class_) # -		-	-	-	-	-	-	-	-	-	- UNUSED, PREV USED HERE
		ApplicationHelper.isa?(o_, class_)
	end

	def timestamps?(o_) # -		-	-	-	-	-	-	-	-	-	-	- UNUSED, PREV USED HERE
		ApplicationHelper.timestamps?(o_)
	end

	def fresh_after?(o_, dt_) # -		-	-	-	-	-	-	-	-	- USED IN FRESH_FOR_USER
		ApplicationHelper.fresh_after?(o_, dt_)
	end

	def fresh_for_user?(o_, user_) # -		-	-	-	-	-	-	-	- 	USED HERE, APPLICATION CONTROLLER
		ApplicationHelper.fresh_for_user?(o_, user_) # -	-	-	-	-	BC IT'S DELICIOUS	
	end
	# -----
	



	# ---- filesystem utility methods
	def asset_exists?(subdirectory, filename)
	  File.exists?(File.join(Rails.root, 'app', 'assets', subdirectory, filename))
	end

	def image_exists?(image)
	  asset_exists?('images', image)
	end

	def javascript_exists?(script)
	  extensions = %w(.coffee .erb .coffee.erb) + [""]
	  extensions.inject(false) do |truth, extension|
	    truth || asset_exists?('javascripts', "#{script}.js#{extension}")
	  end
	end

	def stylesheet_exists?(stylesheet)
	  extensions = %w(.scss .erb .scss.erb) + [""]
	  extensions.inject(false) do |truth, extension|
	    truth || asset_exists?('stylesheets', "#{stylesheet}.css#{extension}")
	  end
	end
	# -----

	# ----- activities, return hashes with result as key 	-	-	-	- UNUSED
	# - 	-	- 	-	-	-	-	-	-	-	-	-
	# - 	-	- 	-	-	-

	# this works
	# Activity.all.order("created_at DESC").group_by{ |i| i.owner_id }
	# Activity.where("date(created_at) = ?",  PublicActivity::Activity.maximum(:created_at).to_date)


	def activities_by_date(a_)
		_a = a_.order(:created_at,).group_by{ |i| i.created_at.to_date.to_s }
		_a
	end

	def activities_by_f(a_)
		_a = a_.all.group_by{ |i| i.created_at.to_f }
		_a
	end
	# -----

	# ----- style
	def uniq_date(dt_, dts_) # -	-	-	-	-	-	-	-	-	- UNUSED
		dts_.include(dt_.strftime("%m%d%y"))
	end

	def date_style(date) # -	-	-	-	-	-	-	-	-	- 	- USED
		_a = date.strftime("%m,%d,%y,%H,%M").split(',')
		_output = content_tag(:span, :class => "dt") do
			_d = content_tag(:span, class: "d") do
				concat content_tag(:date, _a[0])
				concat content_tag(:b, ".")
				concat content_tag(:date, _a[1])
				concat content_tag(:b, ".")
				concat content_tag(:date, _a[2])
			end
			_t = content_tag(:span, class: "t") do
				concat content_tag(:date, _a[3])
				concat content_tag(:b, ":")
				concat content_tag(:date, _a[4])
			end
			concat _d
			concat ( content_tag(:b, "\t") )
			concat _t
		end
		_output
	end
	# -----

	# ----- javascript data params # - 	-	-	-	-	-	-	-	- USED
	# - 	-	- 	-	-	-	-	-	-	-	-	-
	# - 	-	- 	-	-	-
	def sel_snd(id, state: false, group: nil)
		_d = {}
		_d["sel"] = "snd"
		_d["sel-id"] = id
		_d["sel-state"] = state
		_d["sel-group"] = group
		return _d.compact
	end

	def sel_rcv(id, state: false, group: nil)
		_d = {}
		_d["sel"] = "rcv"
		_d["sel-id"] = id
		_d["sel-state"] = state
		_d["sel-group"] = group
		return _d.compact
	end

	def drop_snd(id, state: false)
		_d = {}
		_d["drop"] = "snd"
		_d["drop-id"] = id
		_d["drop-state"] = state
		return _d.compact
	end

	def drop_rcv(id, state: false)
		_d = {}
		_d["drop"] = "rcv"
		_d["drop-id"] = id
		_d["drop-state"] = state
		return _d.compact
	end

	def scroll_snd
	end

	def scroll_rcv
	end
	# --------

	
	# NOTE FOR GET_LOCAL(S): 
	# PROBABLY WANT TO NOT-NAME THE 'LOCALS' INPUT IN THE FUTURE, SO IT REQUIRES LOCAL_ASSIGNS

	# ----- for OPTIONAL LOCAL ATTRIBUTES for PARTIALS and stuff -----
	# - If local_assigns has a key, return it. If not, return false.
	# - 	-	-	-	-	-	-	-	-	-	-	-	-	-	-	- USED
	# - 	-	- 	-	-	-	-	-	-	-	-	-
	# - 	-	- 	-	-	-
	def get_local(locals: {}, key: "", alt: false  ) 
		_local = alt
		if locals.has_key?(key.to_sym)
			_local = locals[key.to_sym]
		elsif locals.has_key?(key.to_s)
			_local = locals[key.to_s]
		end

		return _local 
	end

	

	# - params: {key1: key1deef, key2...}
	def get_locals(locals: {}, params: {})
		_locals = {}
		params.each do |key, value|
			_locals[key] = get_local(locals, key, params[key])
		end
		return _locals
	end

	
	# - get data, classes, merge with second param if you gotta reason
	# - 	-	-	-	-	-	-	-	-	-	-	-	-	-	-	- USED
	# - 	-	- 	-	-	-	-	-	-	-	-	-
	# - 	-	- 	-	-	-
	def get_data(locals: {}, data:{}) 
		_data = get_local(locals: locals, key: "data", alt: {})
		_data = _data.merge(data)
		return _data
	end

	def get_classes(locals: {}, classes:[])
		_classes = get_local(locals: locals, key: "classes", alt: [])
		_classes = _classes + classes
		return _classes
	end

	# ----- PROGRAMMATIC VIEWS # -	-	-	-	-	-	-	-	- UNUSED
	# - 	-	- 	-	-	-	-	-	-	-	-	-
	# - 	-	- 	-	-	-
	# options = {} is a catch-all hash for named args
	# options : {} is a hash arg named options with a default
	def block_to_partial(partial_name, options = {}, &block)
    	options.merge!(:body => capture(&block)) if block_given?
    	render(:partial => partial_name, :locals => options)
	end

	def dd(partial_snd, partial_rcv, options = {}, &block)
	# dropdown from two partials
	# options = {} is a catch-all hash for named args
	# options : {} is a hash arg named options with a default
		ls = {}.merge(options)
		lr = {}.merge(options)
		ls[:data] = drop_snd( options[:id] ).merge( options[:data] || {} )
		lr[:data] = drop_rcv( options[:id] ).merge( options[:data] || {} )

		dd = capture do
			concat(render(partial: partial_snd, locals: ls ))
			concat(render(partial: partial_rcv, locals: lr ))
		end
		dd
	end
	# -----

	def tabbed(hash_, layout: "", classes: "")
		tabs = capture do
			hash_.keys.each_with_index do |key, i|
				concat(
						content_tag :a, 
						"#{key}", 
						data: sel_snd( i, group: 0, state: (i == 0) ) 
					)
			end
		end
		tabbed = capture do
			hash_.values.each_with_index do |value, i|
				concat( 
						content_tag :div, 
						render(value),
						data: sel_rcv( i, group: 0, state: (i == 0) ), 
						class: "col tabbed"
					)
			end
		end
		_content = capture do
			concat( content_tag :div, tabs, class: "row tabs" + classes )
			concat( tabbed )
		end
		_content
	end

	def scroll_link(items)
		is_max = (items.current_page >= items.total_pages)
		url = (is_max) ? "" : url_for(page: items.current_page + 1)
		data = {
			scroll_link: (is_max) ? "0" : "1",
			current: items.current_page,
			total: items.total_pages
		}
		_link = content_tag :div, data: data do
			concat(link_to('...', url))
		end
		_link
	end

	# ----- FROM SOMEWHERE ONLINE:
	# || I've been in this hole too. Here's my solution. Drop this code in your ApplicationHelper:

	# || def concat( content = nil, &block )
	# || output_buffer << ( block_given? ? capture( &block ) : content )
	# || end

	# || And then you can do this:

	# || concat do
	# || content_tag( something ) do
	# || concat something
	# || concat something
	# || end
	# || end
	# --------
end
