# RCalliper
# Marcel Massana 23-Nov-2011
#
# By means of a rotating calliper enables easy calculation of diameter and other features of a convex polygon

module Ubiquity

  module Algorithm

    module RCalliper

      # Shamos Algorithm
      # calculates antipodals of a convex polygon using rotating callipers method
      # http://www.tcs.fudan.edu.cn/rudolf/Courses/Algorithms/Alg_ss_07w/Webprojects/Qinbo_diameter/2d_alg.htm
      # @param points [list of Point that represents a convex polygon]
      # @return array of arrays of two points representing antipodal pairs
      def antipodals(*points)

        # inicialment escombrem per a trobar el primer punt a maxima distancia de p[0]
        i = 0
        paira, pairb = points.last, points[0]
        k = 2
        pt, next_pt = points[1], points[2]
        area_next = nil
        while true do
          area = area_next ? area_next : signed_area(paira, pairb, pt).abs
          area_next = signed_area(paira, pairb, next_pt).abs
          if area_next > area then
            k +=1
            pt, next_pt = next_pt, points[k]
          else
            break
          end
        end
        apdls = [[pairb, pt]] # inicialitzem l'array de parelles antipodals

        # loop per a fer correr els rotating calipers
        dim = points.size
        state = :pairmove
        while  k <= dim do
          case state
            when :pairmove
              i += 1
              paira, pairb = pairb, points[i]
              area_next = nil
              state = :evaldists
            when :evaldists
              area = area_next ? area_next : signed_area(paira, pairb, pt).abs
              area_next = signed_area(paira, pairb, next_pt).abs
              if (area_next > area)
                k += 1
                pt, next_pt = next_pt, points[k % dim]
                apdls << [paira, pt]
              else
                apdls << [pairb, pt]
                state = :pairmove
              end
          end
        end
        apdls.pop # drop last pair. It is the same as the first
        apdls
      end

      # support methods
      private

      # Polygon Area.
      def signed_area(*points)
        last=points.size-1
        if last > 1 then
          sum = points[last].x * points[0].y - points[0].x * points[last].y
          for i in 0.upto(last-1)
            sum += points[i].x * points[i+1].y - points[i+1].x * points[i].y
          end
          sum / 2
        else
          0
        end
      end

    end

  end

end

