module ApplicationHelper
	# ----- CLASS METHODS -----
	# --- can be referenced in controller via ApplicationHelper.method
	# --- can't reference other helper methods that aren't class-methods
	# --- consider move to specific 'universal' helper
	def self.isa?(o_, class_)
		o_.class.name == class_
	end

	def self.timestamps?(o_)
		!(defined?(o_.created_at).nil? || defined?(o_.created_at).nil?)
	end

	def self.fresh_after?(o_, dt_)
		(o_.created_at.to_f >= dt_.to_f) ||
		(o_.updated_at.to_f >= dt_.to_f)
	end

	def self.fresh_for_user?(o_, user_)
		return false unless ( timestamps?(o_) && isa?(user_, "User") )
		# in the future avoid above unless we expect different behavior for each scenario
		# like if we sometimes give it a var that returns false, so we can test that too
		# or we don't want to throw an exception but it's hard to avoid the cause
		# otherwise, it's like overriding "+" to avoid passing incompatible objects

		fresh_after?(o_, user_.last_sign_in_at)
	end

	# array of objects to relation
	def self.to_ar(a_)
		a_.take(1).class.where(id: a_)
	end


	# ----------

	# ----- HELPER METHODS -----
	# - can be referenced in view, and in model, with 'include' 
	# - non-class methods will be overriden by helpers with alphabetically later names

	# ----- from class methods
	def isa?(o_, class_)
		ApplicationHelper.isa?(o_, class_)
	end

	def timestamps?(o_)
		ApplicationHelper.timestamps?(o_)
	end

	def fresh_after?(o_, dt_)
		ApplicationHelper.fresh_after?(o_, dt_)
	end

	def fresh_for_user?(o_, user_)
		ApplicationHelper.fresh_for_user?(o_, user_)
	end
	# -----
	
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

	# ----- activities
	def activities_by_date(a_)
		_a = a_.all.group_by{ |i| i.created_at.to_date.to_s }
		_a
	end
	# -----

	# ----- style
	def uniq_date(dt_, dts_)
		dts_.include(dt_.strftime("%m%d%y"))
	end

	def date_style(date)
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

	# ----- javascript data params
	def sel_snd(id, state: false, off: nil, group: nil)
		_d = {}
		_d["sel-snd"] = id
		_d["sel-state"] = state
		_d["sel-off"] = off
		_d["sel-group"] = group
		return _d.compact
	end

	def sel_rcv(id, state: false, off: nil, group: nil)
		_d = {}
		_d["sel-rcv"] = id
		_d["sel-state"] = state
		_d["sel-off"] = off
		_d["sel-group"] = group
		puts _d.to_yaml
		return _d.compact
	end

	def drop_snd(id, state: false)
		_d = {}
		_d["id"] = id
		_d["drop"] = "toggle"
		_d["state"] = state
		return _d.compact
	end

	def drop_rcv(id, state: false)
		_d = {}
		_d["id"] = id
		_d["drop"] = "target"
		_d["state"] = state
		return _d.compact
	end
	# --------

	# ----- helpers for dynamic partial attributes -----
	def classes2class(hash)
		_hash = {}
		hash.each do |key, value|
			_key = (key == "classes") ? "class" : key
			_hash[_key] = hash[key]
		end
		return _hash
	end

	def get_local(locals: {}, key: "", alt: false  )
		_local = alt
		if locals.has_key?(key.to_sym)
			_local = locals[key.to_sym]
		elsif locals.has_key?(key.to_s)
			_local = locals[key.to_s]
		end
		# puts key
		# puts alt
		# puts locals.to_yaml
		# puts _local.to_yaml

		return _local 
	end


	def get_locals(locals: {}, params: {})
		_locals = {}
		params.each do |key, value|
			_locals[key] = get_local(locals, key, params[key])
		end
		return _locals
	end

	def get_data(locals: {}, data: {})
		_data = {}
		if locals.has_key?("data")
			_data = locals["data"]
			_data = _data.merge(data)
		elsif locals.has_key?(:data)
			_data = locals[:data]
			_data = _data.merge(data)
		end
		
		return _local 
	end

	def deef_params
		return {"data" => {}, "class" => [], "id" => []} # href? image? url?
	end

	def deef_locals(locals: {})
		return get_locals(locals, deef_params)
	end

	def deef_locals(locals: {}, add: {})
		_locals = {}
		deef = get_locals(locals, deef_params)

		deef.each do |key, value|

			_locals[key] = value

			if add.has_key?(key)
				if ["class", "id"].include?(key)
						_locals[key] = _locals[key] + add[key]

				elsif ["data"].include?(key)
						_locals[key] = _locals[key].merge( add[key] )

				end
			end
		end
		return _locals.merge(add)
	end



	#def doofault_content_for(name, &block)
  	#	name = name.kind_of?(Symbol) ? ":#{name}" : name
  	#	out = eval("yield #{name}", block.binding)
  	#	concat(out || capture(&block), block.binding)
	#end
	
	# --------

	def defdAElseB(a_, b_)
		defined?(a_) ? a_ : b_
	end

	# I've been in this hole too. Here's my solution. Drop this code in your ApplicationHelper:

	# def concat( content = nil, &block )
	# output_buffer << ( block_given? ? capture( &block ) : content )
	# end

	# And then you can do this:

	# concat do
	# content_tag( something ) do
	# concat something
	# concat something
	# end
	# end

end
