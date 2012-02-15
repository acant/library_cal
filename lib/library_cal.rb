require 'library_cal/version'
require 'require_directory'
require_directory "#{File.dirname(__FILE__)}/library_cal"

module LibraryCal
	def self.run(arguments)
		library_code = arguments.shift

		library_object = begin
			LibraryCal.const_get(library_code.upcase).new(arguments)
		rescue LoadError
			puts "Sorry, I don't know what library that is."
			return(1)
		#TODO more explicitly catch connect errors
		#TODO catch argument exceptions from library object
		rescue Exception => exception
			puts 'Whoops, something unexpected went wrong.'
			puts "Library Code: #{library_code}"
			puts "Arguments:    #{arguments.join(',')}"
			puts "Error Type:   #{exception.class}"
			puts "Message:      #{exception.message}"
			return(1)
		end

		puts library_object.retrieve.to_ical
		return(0)
	end
end
