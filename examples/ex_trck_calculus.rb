# calculus
# Marcel Massana 1-Nov-2011
#
# calculates some data from GPX files
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

require 'pp'
require 'ubiquity/track_segment'
require 'ubiquity/geoformulas'

my_dir=File.dirname(__FILE__)
fname = 'Mirasol-Can Rabella'

in_file = File.join(my_dir, 'tmp', fname + '.gpx')
out_file = File.join(my_dir, 'tmp', fname + '_out.gpx')

track_segment = Ubiquity::TrackSegment.new

# READ GPX

File.open(in_file,'r') { |f| track_segment.parse_gpx f.read }

puts "Total: #{track_segment.points.count} points"

# MAXIMS, MINIMS, INTERMEDIS I MITJANES
lats = track_segment.points.collect(&:lat)
lons = track_segment.points.collect(&:lon)
elevs = track_segment.points.collect { |p| p.elems["ele"] }
timstart=track_segment.points.first.elems["time"]
timend=track_segment.points.last.elems["time"]
tdif = timend.to_i - timstart.to_i

max = [lats.max, lons.max, elevs.max, timend]
min = [lats.min, lons.min, elevs.min, timstart]
itm = [lats[lats.length/2], lons[lons.length/2], elevs[elevs.length/2],
  timstart+tdif/2]
avr = [lats.inject {|a,l| a+l}/lats.length,
  lons.inject {|a,l| a+l}/lons.length,
  elevs.inject {|a,e| a+e}/elevs.length,
  timstart+tdif/2
]


pp "MAX LAT LON ELE TIM", max
pp "MIN LAT LON ELE TIM", min
pp "ITM LAT LON ELE TIM", itm
pp "AVR LAT LON ELE TIM", avr

# RECORREGUT, TEMPS I VELOCITAT DEL RECORREGUT
dist = track_segment.distance/1000 # Km
time = tdif/3600  # h
vel = dist/time # Km/h

puts "Recorregut: #{dist} Km"
puts "Temps: #{time} hores"
puts "Vel. mitja: #{vel} Km/h"

## DESNIVELLS ACUMULATS
des_net = track_segment.slope
des_up = track_segment.up_slope
des_dwn = track_segment.down_slope
puts "Desnivell Net: #{des_net} m"
puts "Pujada acumulada: #{des_up} m"
puts "Baixada acumulada: #{des_dwn} m"
#
## ALTRES: CENTRE DE GRAVETAT I AREA
#grav_cntr = points.inject { |a,p| a}