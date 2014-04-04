# example_process_gpx
# Marcel Massana 4-Dec-2011

$: << '../lib'

require 'ubiquity'
require 'pp'


my_dir=File.dirname(__FILE__)
fname = 'Mirasol-Can Rabella'

in_file = File.join(my_dir, 'tmp', fname + '.gpx')
out_file = File.join(my_dir, 'tmp', fname + '_out.gpx')

track_segment_in = Ubiquity::TrackSegment.new

# READ GPX
File.open(in_file,'r') { |f| track_segment_in.parse_gpx f.read }
puts "Total: #{track_segment_in.points.count} points"

# PROCESS TRACKSEGMENT
#elevs_in = Ubiquity::Helpers::Enumerable.extract(track_segment_in.points) {|p| p.elems['ele']}
elevs_in = track_segment_in.elevations
elevs_out = Ubiquity::Filters.moving_average(elevs_in,7)


pp Ubiquity::Helpers::Enumerable.compose(elevs_in,elevs_out)