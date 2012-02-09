require "library_cal/version"
require "bundler"
Bundler.setup

module LibraryCal
	def self.run(arguments)
		library_object = case arguments[0]
		when 'kpl' then
			require "library_cal/kpl"
			LibraryCal::KPL.new(arguments.slice(1))
		when 'wpl' 
			require "library_cal/wpl"
			LibraryCal::WPL.new(arguments.slice(1))
		else
			puts "Sorry, I don't know what library that is."
			exit(1)
		end

		puts library_object.parse(library_object.retrieve()).to_ical
	end
end
