# Algorithm
# Marcel Massana 23-Nov-2011
#
# Computational Geometry Algorithms to use within Euclidean Plane. Use with convenient projections with GPS data,

require 'ubiquity/algorithms/convex_hull'
require 'ubiquity/algorithms/rcalliper'

module Ubiquity

  module Algorithms

    include ConvexHull
    include RotatingCalliper

    extend self

  end

end