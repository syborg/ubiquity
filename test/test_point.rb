# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'rubygems'
require 'test/unit'
require 'ubiquity/point'


class TC_Point < Test::Unit::TestCase

  def setup
    @point1 = Ubiquity::Point.new 41.567299, 1.904531
    @point2 = Ubiquity::Point.new 41.567276, 1.904553
    @d = @point1.to @point2
  end

  def teardown

  end

  def test_equality
    @point3 = Ubiquity::Point.new 41.567299, 1.904531
    assert_equal true, (@point1 == @point3)
    end

  def test_not_equality_1
    @point3 = Ubiquity::Point.new 41.567299, 1.904530
    assert_equal false, (@point1 == @point3)
  end

  def test_not_equality_2
    @point3 = Ubiquity::Point.new 41.567298, 1.904531
    assert_equal false, (@point1 == @point3)
  end

  def test_not_equality_3
    @point3 = Ubiquity::Point.new 41.567298, 1.904530
    assert_equal false, (@point1 == @point3)
  end

  def test_distance
    d = @point1.to @point2
    assert_equal d, @point2.to(@point1)
  end

  def test_angle
    a = @point1.angle_to @point2
    b = @point2.angle_to @point1
    assert_equal 180, a-b
  end

  def test_inside_circle?
    assert_equal true, @point1.inside_circle?(@point2, @d)
  end

  def test_not_inside_circle?
    assert_equal false, @point1.inside_circle?(@point2, @d-0.0000000001)
  end

  def test_inside_rect?
    p = @point1.midpoint @point2
    assert_equal true, p.inside_rect?(@point1, @point2)
  end

  def test_not_inside_rect1?
    p = @point1.midpoint @point2
    assert_equal false, @point1.inside_rect?(p, @point2)
  end

  def test_not_inside_rect2?
    p = @point1.midpoint @point2
    assert_equal false, @point2.inside_rect?(p, @point1)
  end

end
