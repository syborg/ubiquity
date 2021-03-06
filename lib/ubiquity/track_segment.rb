# TrackSegment
# Marcel Massana 12-Nov-2011

require 'rubygems'
require 'nokogiri'
require 'time'
require 'ubiquity/error'
require 'ubiquity/point'

module Ubiquity

  class TrackSegment

    attr_accessor :points

    # creates a TrackSegment. If Array pts given those points will conform the TrackSegment
    def initialize(pts = nil)
      self.points = Array.new
      self.add_points pts if pts
    end

    # Adds new points to the end of TrackSegment. If any problem no points are added.
    # @param args [list of Points, TrackSegments or Arrays of any combination of them]
    # @ retuns self if OK, nil if not added elements
    def add_points *args
      last = self.points.length
      args.each do |arg|
        case arg
          when Point then
            self.points << arg
          when TrackSegment then
            self.points += arg.points
          when Array then
            arg.each { |a| add_points a }
          else
            raise Ubiquity::Error::BadArgument, "args should be a list of Points, TrackSegments or Arrays of any of them"
        end
      end
      clean_memoized # ensures future recalculations
      self
    rescue
      self.points.slice!(last..-1) # in case of error eliminates added elements if any
      nil
    end

    alias << add_points
    alias concatenate! add_points
    alias join! add_points

    # Creates a new TrackSegment concatenating to the end of self a new TrackSegment,
    # @param ts [TrackSegment]
    # @return [TrackSegment]
    def +(ts)
      self.clone.add_points ts
    end

    # accepts a gpx (xml) string and parses its first track segment
    def parse_gpx(gpx)
      doc = Nokogiri::XML(gpx) # parse whole file into a Nokogiri document
      doc = doc.at('trkseg') # BTM select first track segment (others may exist: metadata, tracks, waypoints, routes)

      # Find out all points
      doc.search("trkpt").each do |tp|
        lat = tp['lat'].to_f
        lon = tp['lon'].to_f

        # other elements within a trackpoint
        elems = {}
        if ele = tp.at("ele") then
          elems["ele"] = ele.text.to_f;
        end # elevation
        if time = tp.at("time") then
          elems["time"] = Time.parse(time.text);
        end # time
        if sat = tp.at("sat") then
          elems["sat"] = sat.text.to_i;
        end # number of satelites

        self.add_points Point.new(lat, lon, elems)
      end
    end

    alias from_gpx parse_gpx

    def to_gpx
      Nokogiri::XML::Builder.new do |xml|
        xml.gpx("version" => "1.1",
                "creator" => "Ubiquity",
                "xmlns" => "http://www.topografix.com/GPX/1/1",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                "xsi:schemaLocation" => "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd") {
          #  xml.metadata {
          #    xml.lnk("href" => "www.marcel.com") {
          #      xml.text_ {   # '_' al final assegura que sera un tag i desambigua del metode text
          #        xml.text "Aixo es una prova"  # aqui text es el metode que inclou un texte
          #      }
          #    }
          #  }
          xml.trk {
            xml.trkseg {
              points.each do |p|
                xml.trkpt("lat"=>p.lat, "lon"=>p.lon) {
                  p.elems.each do |k, v|
                    val = case v
                            when Time then
                              v.iso8601
                            else
                              v.to_s
                          end
                    xml.send k, val
                  end
                }
              end
            }
          }
        }
      end.to_xml
    end

    alias generate_gpx to_gpx
    alias to_xml to_gpx

    # returns an array of elevations if there is such data, else nil. Only first point is checked to decide if there is
    # elevation data in the whole TrackSegment
    def elevations
      if (elems = self.points.first.elems) && elems.has_key?('ele')
        self.points.map { |p| p.elems['ele'] }
      else
        nil
      end
    end

    # returns the total distance in meters
    def distance
      # we use memoization because calculating distance is expensive
      @distance ||= begin
        self.points.inject(nil) do |a, p|
          new_pt = p
          if a
            last_pt = Ubiquity::Point.new(a[:last_lat], a[:last_lon], {'ele' => a[:last_ele]})
            d = last_pt.to new_pt
            a[:dist] += d
          else
            a=Hash.new
            a[:dist]=0
          end
          a[:last_lat]=new_pt.lat
          a[:last_lon]=new_pt.lon
          a[:last_ele]=new_pt.elems['ele']
          a
        end[:dist]
      end
    end

    # Total net slope from beginning to end in meters
    def slope
      # we use memoization because calculating slope is expensive
      @slope ||= begin
        self.points.first.elems['ele'] - self.points.last.elems['ele']
      end
    end

    # Total accumulated up slope from beginning to end in meters
    def up_slope
      # we use memoization because calculating slope is expensive
      @up_slope ||= begin
        self.points.inject(nil) do |a, p|
          new_ele = p.elems["ele"]
          if a
            last_ele = a[:last_ele]
            inc = new_ele - last_ele
            a[:up] += inc if inc > 0
          else
            a=Hash.new
            a[:up] = 0
          end
          a[:last_ele] = new_ele
          a
        end[:up]
      end
    end

    # Total accumulated down slope from beginning to end in meters
    def down_slope
      # we use memoization because calculating slope is expensive
      @down_slope ||= begin
        self.points.inject(nil) do |a, p|
          new_ele = p.elems["ele"]
          if a
            last_ele = a[:last_ele]
            dec = last_ele - new_ele
            a[:down] += dec if dec > 0
          else
            a=Hash.new
            a[:down] = 0
          end
          a[:last_ele] = new_ele
          a
        end[:down]
      end
    end

    def convex_hull
      @convex_hull ||= Algorithms.convex_hull(*self.points)
    end

    private

    # cleans internally precalculated (memoized) data.
    def clean_memoized
      @distance = nil
      @slope = nil
      @up_slope = nil
      @down_slope = nil
      @convex_hull = nil
    end

  end
end