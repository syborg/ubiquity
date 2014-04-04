# point calculus
# Marcel Massana 15-Nov-2011

$: << '../lib'

require 'ubiquity/point'
require 'pp'

point1 = Ubiquity::Point.new 41.567299, 1.904531
point2 = Ubiquity::Point.new 41.567276, 1.904553

puts "distancia 1-2 = #{point1.to point2} m"
puts "distancia 2-1 = #{point2.to point1} m"
puts "angle 1-2 = #{point1.angle_to point2} deg"
puts "angle 2-1 = #{point2.angle_to point1} deg"

pp point1.midpoint point2
pp point2.midpoint point1

mp = point1.halfway point2
pp mp.inside_rect?(point1, point2)
pp mp.inside_rect?(point2, point1)
pp point1.inside_rect?(point2, mp)

# Nubol de punts
points = [
41.612114, 1.854197,
41.612087, 1.854283,
41.612068, 1.854284
].each_slice(2).map {|p| Ubiquity::Point.new *p}
pp points
# Rectangle que conté el nubol de punts
p1, p2 = Ubiquity::Point.container_rect(*points)
#longitud de la diagonal
puts p1.to p2
# cercle que conte el (rectangle que conte) el nubol de punts
cercle = Ubiquity::Point.container_circle(*points)
# centre i radi
pp cercle
