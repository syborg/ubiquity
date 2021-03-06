# gpx_parser
# Marcel Massana 13-Nov-2011
#
# read and generate a gpx file
#
# veure gpx.xsd i http://www.w3schools.com/schema/schema_howto.asp
# Estructura essencial en quant a tracks (elements a parsejar):
# gpx (element node)
#   ... (elements no necessaris)
#   trk (tracks: poden haber-ne 0 o mes)
#     ... (elements no necessaris)
#     trkseg (tracksegment: poden haber-ne 0 o mes)
#       trkpt  (trackpoint: poden haber-ne 0 o mes)
#         lat atribut (latitut: graus en decimal en l'interval [-90, 90], WGS84 datum)
#         lon atribut (longitut: graus en decimal en l'interval [-180, 180), WGS84 datum)
#         ele (elevation: pot haver-ne 0 o 1. conte la elevacio en coma flotant.)
#         time (pot haver-ne 0 o 1. instant de temps UTC -no local- en format ISO 8601)
#         ...
#         sat  (pot haver-ne 0 o 1. nombre de satelits utilitzats)
#         ...
#
#       ... (elements no necessaris)

$: << '../lib'

require 'ubiquity/track_segment'

my_dir=File.dirname(__FILE__)
fname = 'Mirasol-Can Rabella'

in_file = File.join(my_dir, 'tmp', fname + '.gpx')
out_file = File.join(my_dir, 'tmp', fname + '_out.gpx')

track_segment = Ubiquity::TrackSegment.new

# READ GPX

File.open(in_file,'r') { |f| track_segment.parse_gpx f.read }

puts "Total: #{track_segment.points.count} points"

# WRITE GPX

File.open(out_file,'w') { |f| f.write track_segment.to_gpx }

puts track_segment.to_gpx