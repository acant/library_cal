require 'library_cal'
require 'library_cal/kpl'

describe LibraryCal::KPL do
	describe 'retrieve method' do
	end

	describe 'parse method' do
		before(:each) do
			@sut = LibraryCal::KPL.new([])
		end

		it 'should correctly parse example KPL HTML file' do
			result = @sut.parse(File.open("examples/kpl.html", "rb").read)
			result.events.count.should == 2

			result.events[0].dtstart.should     == Date.new(2012, 2, 26)
			result.events[0].summary.should     == "Books due at Kitchener Public Library"
			result.events[0].description.should == "Fuzzy nation / John Scalzi. --
Insurgents, raiders, and bandits : how masters of irregular warfare have shaped our world / John Arqu
Till human voices wake us
The big enough company : creating a business that works for you / Adelaide Lancaster and Amy Abrams."

			result.events[1].dtstart.should     == Date.new(2012, 2, 12)
			result.events[1].summary.should     == "Books due at Kitchener Public Library"
			result.events[1].description.should == "This beautiful city [DVD] / Three Legged Dog Films and Resolute Films and Entertainment Production ;
West is west [DVD] / BBC Films presents ; a Leslee Udwin/Assassin Films production ; produced by Lesl"

		end
	end
end
