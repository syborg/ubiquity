# Array
# Marcel Massana 2-Dec-2011
#
# Adds some useful methods to arrays

class Array

  # Iterates over an Array yielding a (sub) Array consisting of width elements each time, that is useful to make some
  # data series processing as filters and moving averages. To ensure that the output is of the same length as the input
  # and isn't delayed, first and last values of the array are used to pad the firsts and lasts iterations.
  # (By the way, a delay or advance of half a point is unavoidable when width is an even number because the original
  # samples cannot be placed at the center of the window, there isn't a center point)'
  # @return an Array with the returned values of each iteration
  #
  # Examples
  # [1,2,3,4,5].each_sliding_window { |w| w.count }  # => [1,1,1,1,1]
  # [1,2,3,4,5].sliding_window(5) { |w| w.inject {|a,v| a+v}.to_f/w.count } # =>  [1.6, 2.2, 3.0, 3.8, 4.4]
  def sliding_window(width=1)

    # calculate initial and final padding lengths
    n=width.to_f/2
    if n==n.to_i # even
      n=n.to_i
      m=n-1
    else      # odd
      n=n.to_i
      m=n
    end

    out = []
    self.unshift(*Array.new(n,self.first)) if n>0
    self.push(*Array.new(m,self.last)) if m>0
    self.each_cons(width) { |a| out << yield(a) }
    self.shift(n) if n>0
    self.pop(m) if m>0
    out
  end

  alias sw sliding_window



end