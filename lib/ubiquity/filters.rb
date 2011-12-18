# Filters
# Marcel Massana 2-Des-2011
#
# Data series filters

require 'ubiquity/array'

module Ubiquity

  # some filters to process data
  module Filters

    extend self

    # Calculates median of elements of an array
    # @param array [Array of elements that must be comparable (method .<=> defined)]
    # @param block [if given, block will be passed each element and should return a comparable value (method .<=> defined)]
    # @return [the central element after being ordered]
    def median(array, &block)
      if block_given?
        array.sort_by { |v| block.call(v) }[array.size/2]
      else
        array.sort[array.size/2]
      end
    end

    # Calculates maximum of elements of an array
    # @param array [Array of elements that must be comparable (method .<=> defined)]
    # @param block [if given, block will be passed each element and should return a comparable value (method .<=> defined)]
    # @return [the central element after being ordered]
    def max(array, &block)
      if block_given?
        array.sort_by { |v| block.call(v) }.last
      else
        array.sort.last
      end
    end

    # Calculates minimum of elements of an array
    # @param array [Array of elements that must be comparable (method .<=> defined)]
    # @param block [if given, block will be passed each element and should return a comparable value (method .<=> defined)]
    # @return [the central element after being ordered]
    def min(array, &block)
      if block_given?
        array.sort_by { |v| block.call(v) }.first
      else
        array.sort.first
      end
    end

    # Calculates average of elements of an array
    # @param array [Array of elements to which .to_f will be applied for averaging purposes]
    # @param block [if given, block will be passed each element and should return a value to which .to_f will be applied
    # for averaging purposes]
    # @return [a float average of the array]
    def average(array, &block)
      array.inject(0.0) do |a, e|
        a + if block_given?
              block.call(e).to_f
            else
              e.to_f
            end
      end / array.length
    end

    # Applies moving median, average, or any other filter functions defined in this module to an Array as far as
    # follow the naming convention moving_median, sliding_median, moving_average, ... The resulting Array will have
    # same length and will contain the results of applying the filter to each moving window. Initial and final
    # padding is done with the initial and final elements (see Array#sliding_window)
    # The accepted arguments are
    # @param array [Array of elements]
    # @param width [width of the sliding window where the filter will be applied]
    # @return [Array]
    def method_missing(name, *args, &block)
      case name.to_s # name is a Symbol and should be converted to a String
                     # moving_average, moving_median, ...
        when /(?:moving|sliding)_(.*)/ then
          if %w{average median max min}.include? $1
            array = args[0]
            width = args[1] || 1 # defaults to 1
            array.sliding_window(width) { |w| self.send($1, w, &block) }
          else
            super
          end
        else
          super
      end
    end

  end

end