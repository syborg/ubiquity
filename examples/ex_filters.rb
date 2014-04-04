# Proves de Filters
# Marcel Massana 3-Dec-2011

$: << '../lib'

require 'ubiquity/filters'
require 'pp'

arr=%w{hola adeu benvinguts petards}
lens=arr.map {|e| e.length}

pp arr
pp lens

pp Ubiquity::Filters.moving_median(arr,3)
pp Ubiquity::Filters.moving_median(arr,3) {|w| w.length}
pp Ubiquity::Filters.moving_median(arr,3) {|w| 1/w.length}

pp Ubiquity::Filters.moving_average(arr,3)
pp Ubiquity::Filters.moving_average(arr,3) {|w| w.length.to_f}
pp Ubiquity::Filters.moving_average(arr,3) {|w| 1/w.length.to_f}