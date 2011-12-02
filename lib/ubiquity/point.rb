# Point
# Marcel Massana 12-Nov-2011

require 'ubiquity/geoformulas'
require 'ubiquity/algorithms'
#require 'rubygems'
#require 'mme_tools/debug'

module Ubiquity

  # Geographic Point
  #
  # A part of lon and lat, it mantains x and y as aproximate projections to a plane tha can be used with
  # algorithms for euclidean plane. For instance:
  #
  #
  class Point

    RAD_PER_DEG = Math::PI/180.0 # PI/180 rad/deg
    PROJECTION_LATITUDE = RAD_PER_DEG * 45 # to project longitudes

    # Class latitude used to make projections (calculate x from lon)

    # sets the latitude used to project longitudes to x
    def self.projection_lat=(val)
      @@proj_lat = val
    end

    # returns the latitude used to project longitudes to x
    def self.projection_lat
      @@proj_lat
    end

    # Getters and Setters

    attr_reader :lon, :lat # floats
    attr_accessor :elems # hash of additional features such as time, elevation, ...
    alias y lat

    def lat=(lat)
      @lat = lat
      @x = nil
    end

    def lon=(lon)
      @lon = lon
      @x = nil
    end

    def x
      @x ||= lon * Math.cos(@@proj_lat) # memoized
    end

    # constructor ...
    def initialize (lat, lon, elems = nil)
      @@proj_lat ||= PROJECTION_LATITUDE
      self.lat=lat
      self.lon=lon
      self.elems = elems
    end

    # overrides Object#== equality test to make Array#include? work with Point
    def ==(p)
      (self.lat == p.lat) && (self.lon == p.lon)
    end

    # returns the distance from self to point
    def distance_to(point)
      d=Ubiquity::Geoformulas.distance self.lat, self.lon, point.lat, point.lon
      if self.elems && self.elems.has_key?('ele') && point.elems.has_key?('ele')
        d=Ubiquity::Geoformulas.distance_correction d, self.elems['ele'], point.elems['ele']
      end
      d
    end

    alias to distance_to
    alias from distance_to

    # returns de angle of the path to point
    def angle_to(point)
      Ubiquity::Geoformulas.angle self.lat, self.lon, point.lat, point.lon
    end

    alias phase_to angle_to
    alias bearing_to angle_to

    # returns the point halfway between self to point
    def midpoint(point)
      la, lo = Ubiquity::Geoformulas.midpoint self.lat, self.lon, point.lat, point.lon
      self.class.new la, lo
    end

    alias halfway midpoint

    # given a list of points returns a couple of points that define the
    # minimum container rectangle
    def self.container_rect(*points)
      lats = points.collect(&:lat)
      lons = points.collect(&:lon)
      p1 = self.new lats.min, lons.min
      p2 = self.new lats.max, lons.max
      [p1, p2]
    end

    # given a list of points returns a point and a radius that define a
    # container circle
    def self.container_circle(*points)
      p1, p2 = self.container_rect *points
      mid = p1.midpoint p2
      d = p1.to(p2) / 2
      [mid, d]
    end

    # returns true if self is within a circle centered at point with radius
    def inside_circle?(point, radius)
      (self.distance_to(point) <= radius)
    end

    alias within_circle? inside_circle?
    alias in_circle? inside_circle?

    # returns true if self is wthin a rectangle defined by two points
    def inside_rect?(point1, point2)
      lats = [point1.lat, point2.lat].sort
      lons = [point1.lon, point2.lon].sort
      la = self.lat
      lo = self.lon

      (la >= lats[0] && la <= lats[1] && lo >= lons[0] && lo <= lons[1])
    end

    alias within_rect? inside_rect?
    alias in_rect? inside_rect?

    def self.convex_hull(*points)
      Ubiquity::Algorithms.convex_hull *points
    end

  end

end
