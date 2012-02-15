require 'nokogiri'
require 'icalendar'
require 'date'
require 'mechanize'

class LibraryCal::KPL
	include Icalendar

	def initialize(arguments)
		#TODO add exception about needing 3 arguments
		@name     = arguments.shift
		@bar_code = arguments.shift
		@pin      = arguments.shift
	end

	NAME="Kitchener Public Library"
	def name
		return NAME
	end

	def retrieve
		agent = Mechanize.new
		login_page = agent.get('https://books.kpl.org/iii/cas/login?service=https%3A%2F%2Fbooks.kpl.org%3A443%2Fpatroninfo~S1%2FIIITICKET&scope=1')

		login_form = login_page.forms[0]
		login_form['name'] = @name
		login_form['code'] = @bar_code
		login_form['pin']  = @pin

		main_page = login_form.submit() #login_form.buttons.first)

		items_page = main_page.links.
			find { |l| l.text =~ /currently checked out/ }.
			click

		parse(items_page.parser, items_page.uri)
	end

	def parse(doc, url)
		#ASSERT doc looks like a Nokogiri parser

		#Extract dues dates into a hash...
		due_dates = {}
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
