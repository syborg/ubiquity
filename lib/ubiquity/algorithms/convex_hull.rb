# Convex Hull
# Marcel Massana 23-Nov-2011
#
# Calculates the convex hull of a path or a group of points, that is, the minimum enclosing polygon

module Ubiquity

  module Algorithms

    module ConvexHull

      # Graham Scan Algorithm (after Graham & Andrew)
      # returns a the convex hull (minimum convex polygon that encloses all
      # given points)
      # http://marknelson.us/2007/08/22/convex/
      # input should be any set of unique points (not repeated, it is important!)
      # output is a list of points beginning from the left most one in
      # counterclockwise order that define the convex hull.
      # @param points [list of Points]
      # @returns list of Points representing the convex hull
      def convex_hull(*points)
        # patch to assure unique points
        #upoints = points.inject([]) { |a, p| a << p unless a.include?(p); a }
        #upoints = points

        lop = points.sort_by(&:x)
        left = lop.shift
        right = lop.pop

        # classify points in upper and lower ones
        grouper = determinant_function left, right
        groups = lop.group_by { |p| grouper.call(p) <=> 0 }
        upper, lower = groups[-1], groups[1]

        # construct lower hull
        lower ||=[]
        lower << right # append right to check convexity of next to last point
        lower_hull = [left]
        lower.each do |p|
          lower_hull << p
          while (lower_hull.size >= 3) && convex?(lower_hull[-3..-1], true) do
            lower_hull.delete_at(-2) # eliminates next to last elem
          end
        end

        # construct upper hull
        upper ||=[]
        upper << right # append right to check convexity of next to last points
        upper_hull = [left]
        upper.each do |p|
          upper_hull << p
          while (upper_hull.size >= 3) && convex?(upper_hull[-3..-1], false) do
            upper_hull.delete_at(-2) # eliminates next to last elem
          end
        end

        # from left to right counterclockwise
        lower_hull.pop
        upper_hull.shift
        lower_hull+ upper_hull.reverse
      end

      # support methods
      private

      # Torna l'area amb signe del triangle format per p0, p1 i p. Si es positiva,
      # p esta per sobre de la linea entre p0 i p1, si es negatiu p està per sota,
      # i si es 0 vol dir que p es colineal (sobre la linea)
      def determinant_function(p0, p1)
        proc { |p| ((p0.x-p1.x)*(p.y-p1.y))-((p.x-p1.x)*(p0.y-p1.y)) }
      end

      # @param list_of_three [three points]
      # @param lower [true means lower, false is upper]
      def convex?(list_of_three, lower)
        p0, p1, p2 = list_of_three
        cmp = (determinant_function(p0, p2).call(p1) > 0)
        lower ? (! cmp) : cmp
      end

    end

  end

end

