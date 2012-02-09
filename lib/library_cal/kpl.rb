require 'nokogiri'
require 'icalendar'
require 'date'

class LibraryCal::KPL
	include Icalendar

	def initialize(arguments)
		@name   = arguments.shift
		@number = arguments.shift
		@pin    = arguments.shift
	end

	NAME="Kitchener Public Library"
	def name
		return NAME
	end

	def retrieve
	end

	def parse(html_data)

		#Extract dues dates into a hash...
		due_dates = {}
		doc = Nokogiri::HTML(html_data)
		doc.css('table tr.patFuncEntry').each do |record|
			anchor = record.css('.patFuncTitle a').first
			title  = anchor.text.strip

			date_match = record.css('.patFuncStatus').text.chomp.match(
				/^.*DUE ([0-9]{2})-([0-9]{2})-([0-9]{2}).*$/
			)
			due_date = Date.new(
				"20#{date_match[3]}".to_i, date_match[1].to_i, date_match[2].to_i
			)

			due_dates[due_date] = [] unless due_dates.has_key?(due_date)
			due_dates[due_date].push(title)
		end

		#...and turn those dates into icalendar events.
		icalendar = Calendar.new
		due_dates.each_pair do |key,value|
			icalendar.event do
				dtstart       key
				#dtend         key
				summary     "Books due at #{NAME}"
				description value.join("\n")
			end
		end
		icalendar
	end
end
