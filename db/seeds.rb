# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


kn_sc = know_seeds_config = 
{
	e_n: 	30,								# total events
	e_cn: 	16,								# max comments per event
	e_cmn: 	10.days.ago,					# earliest created_at
	e_dmn: 	5.days.ago,						# earliest starts_at/ends_at
	e_dmx: 	5.days.from_now,				# latest starts_at/ends_at
	e_lmx: 	10.hours,						# longest event duration
	c_tch:  50,								# max length of title (characters)
	c_bch:  200,							# max length of body (characters)
	c_bmn: 	1,								# min length of body (lines)
	c_bmx: 	5 								# max length of body (lines)
}
#kn_sc = know_seeds_config = { 	e_n: 10, 	c_n: 30, 	e_cmn: 10.days.ago, 	e_dmn: 5.days.ago, 	e_dmx: 5.days.from_now, 	e_lmx: 10.hours, 	c_bmn: 1, 	c_bmx: 6 }

def eventParams(i, kn_sc) 
	e = {}
	e[:name] 		= 	Faker::Company.catch_phrase.titleize #[Faker::Hacker.ingverb.capitalize, Faker::Book.title].join(" ") OR Faker::Company.catch_phrase
	e[:description] = 	Faker::Hacker.say_something_smart
	e[:user] 		= 	User.where( id: User.pluck(:id)[ rand(1..User.count) - 1] ).first

	e[:starts_at] 	= 	Faker::Time.between(kn_sc[:e_dmn], 5.days.from_now, :all)
	e[:ends_at] 	= 	Faker::Time.between(e[:starts_at], e[:starts_at] + kn_sc[:e_lmx], :all)
	e[:created_at] 	= 	Faker::Time.between( kn_sc[:e_cmn], Time.now, :all)
	e[:updated_at] 	= 	Faker::Time.between(e[:created_at], Time.now, :all)
	e
end

puts "----- SEED EVENTS -----"
kn_sc[:e_n].times do |i|

	e = eventParams(i, kn_sc)

	event = Event.create(e)
	if (event.save!)
		puts "event: #{i}/#{Event.count} \t---\t saved!"
	else
		puts "event: #{i}/#{Event.count} \t---\t not saved!"
	end
end
puts "--------"

def userId
	User.pluck(:id)[ rand(1..User.count) - 1]
end

def commentParams(e, i, kn_sc)
	c = {}
	c.clear
	c[:commentable] = c[:root] = 		e
	c[:user] = 			 				User.where( id: User.pluck(:id)[ rand(1..User.count) - 1 ] ).first #not random, not a closure

	c[:title] = 						Faker::Hacker.say_something_smart.split(",").first
	c[:title] = 						c[:title].slice(0, kn_sc[:c_tch])

	b_len = rand(kn_sc[:c_bmn]..kn_sc[:c_bmx])
	c[:comment] = 						Array.new( b_len ) 	{ Faker::Hacker.say_something_smart.split(",").first << " " }.inject{ |sum, x| sum << x}
	c[:comment] = 						c[:comment].slice(0, kn_sc[:c_bch])

	
	c[:role] = 							( c[:user].id == c[:commentable].user_id) ? "owner" : "default"
	c[:public] = 						( c[:role] == "default" ) && ( rand(0..3) > 0 )	#not random, not a closure
	c[:created_at] 	= 	Faker::Time.between( e.created_at, 	Time.now, :all)
	c[:updated_at] 	= 	Faker::Time.between( c[:created_at], Time.now, :all)
	c
end

# in comments for each event between 0 and max
puts "----- SEED COMMENTS -----"
Event.find_each do |e|	
	rand(0..kn_sc[:e_cn]).times do |i|
	
		c = commentParams(e, i, kn_sc)

		comment = Comment.create(c)
		if (comment.save!)
			puts "comment: #{i}/#{e.comments.count}/#{Comment.count} \t---\t saved!"
		else
			puts "comment: #{i}/#{e.comments.count}/#{Comment.count} \t---\t not saved!"
		end
	
	end
end
puts "--------"


Comment.find_each do |comment| 
	comment.activity_for_create
end