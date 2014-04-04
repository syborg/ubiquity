# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'minitest/autorun'
require 'ubiquity/filters'

class TC_Filters < Minitest::Test

  def setup

  end

  def teardown

  end

  def test_median_odd
    arr=[3, 2, 5, 4, 1]
    assert_equal 3, Ubiquity::Filters.median(arr)
  end

  def test_median_even
    arr=[3, 2, 4, 1]
    assert_equal 3, Ubiquity::Filters.median(arr)
  end

  def test_median_short
    arr=[1]
    assert_equal 1, Ubiquity::Filters.median(arr)
  end

  def test_median_with_block
    arr=%w{un dos tres}
    assert_equal "dos", Ubiquity::Filters.median(arr) {|s| s.length}
  end

  def test_max
    arr=[3, 2, 4, 1]
    assert_equal 4, Ubiquity::Filters.max(arr)
  end

  def test_max_with_block
    arr=%w{un dos tres}
    assert_equal "tres", Ubiquity::Filters.max(arr) {|s| s.length}
  end

  def test_min
    arr=[3, 2, 4, 1]
    assert_equal 1, Ubiquity::Filters.min(arr)
  end

  def test_min_with_block
    arr=%w{un dos tres}
    assert_equal "un", Ubiquity::Filters.min(arr) {|s| s.length}
  end

  def test_average_odd
    arr=[3, 2, 5, 4, 1]
    assert_equal 3, Ubiquity::Filters.average(arr)
  end

  def test_average_even
    arr=[3, 2, 4, 1]
    assert_equal 2.5, Ubiquity::Filters.average(arr)
  end

  def test_average_short
    arr=[1]
    assert_equal 1, Ubiquity::Filters.average(arr)
  end

  def test_moving_median1
    arr=[3, 2, 5, 8, 5, 1]
    assert_equal arr, Ubiquity::Filters.moving_median(arr)
  end

  def test_moving_median2
    arr=[3, 2, 5, 8, 5, 1]
    assert_equal [3, 3, 5, 8, 8, 5], Ubiquity::Filters.moving_median(arr, 2)
  end

  def test_moving_median5
    arr=[3, 2, 5, 8, 5, 1]
    assert_equal [3, 3, 5, 5, 5, 1], Ubiquity::Filters.moving_median(arr, 5)
    end

  def test_moving_max3
    arr=[3, 2, 5, 8, 5, 1]
    assert_equal [3,5,8,8,8,5], Ubiquity::Filters.moving_max(arr, 3)
  end

  def test_moving_min3
    arr=[3, 2, 5, 8, 5, 1]
    assert_equal [2,2,2,5,1,1], Ubiquity::Filters.moving_min(arr, 3)
  end

  def test_moving_average1
    arr=[3, 2, 5, 8, 5, 1]
    assert_equal arr, Ubiquity::Filters.moving_average(arr)
  end

  def test_moving_average2
    arr=[3, 2, 5, 8, 5, 1]
    assert_equal [3.0, 2.5, 3.5, 6.5, 6.5, 3.0], Ubiquity::Filters.moving_average(arr, 2)
  end

  def test_moving_average5
    arr=[3, 2, 5, 8, 5, 1]
    assert_equal [3.2, 4.2, 4.6, 4.2, 4.0, 3.2], Ubiquity::Filters.moving_average(arr, 5)
  end

end
