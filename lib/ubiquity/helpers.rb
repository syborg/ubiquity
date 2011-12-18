# Helpers
# Marcel Massana 13-Nov-2011

module Ubiquity

  module Helpers

    module Enumerable

      extend self

      # returns an array where each element is a part of the elements of the original array. Almost an Array#map wrapper
      # @param enumerable [enumerable as an array]
      # @param attr [the name of an attribute to extract from each element]
      # If no attr is given and a block is given, that block will be passed each element and its result will be stored
      # in the resulting array
      # @return [Arry with the results or nil]
      def extract(enumerable, attr = nil)
        if attr
          enumerable.map { |e| e.send(attr.to_sym)}
        elsif block_given?
          enumerable.map { |e| yield e }
        else
          nil
        end
      end

      # returns an array where each element is a tupla created by one element of each enumerable os, if a block is passed,
      # the result of passing this tupla to the block.
      def compose(*enumerables)
        res=[]
        enumerables.map(&:size).max.times do
          tupla=[]
          for enumerable in enumerables
            tupla << enumerable.shift
          end
          res << (block_given? ? yield(tupla) : tupla)
        end
        res
      end

    end

  end

end
