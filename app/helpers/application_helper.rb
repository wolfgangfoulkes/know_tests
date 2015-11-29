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
	# -----
end
