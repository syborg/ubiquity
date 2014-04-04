# test helper
# Marcel Massana 4-Dec-2011

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require "minitest/autorun"
require "ubiquity/helpers"


class TC_Helper < Minitest::Test

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    p = Struct.new(:x, :y)
    @arr=[p.new(1, 2), p.new(3, 4), p.new(5, 6), p.new(7, 8)]
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_extract_with_attr
    assert_equal [1, 3, 5, 7], Ubiquity::Helpers::Enumerable.extract(@arr, 'x')
  end

  def test_extract_with_block
    assert_equal [2,12,30,56],  Ubiquity::Helpers::Enumerable.extract(@arr) {|e| e.x*e.y}
  end

  def test_compose
    assert_equal [[1,'a'],[2,'b'],[3,'c']], Ubiquity::Helpers::Enumerable.compose([1,2,3], %w{a b c})
  end

end