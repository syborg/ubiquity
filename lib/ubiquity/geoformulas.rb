# geoformulas
# Marcel Massana 13-Nov-2011
#
# Some formulas to calculate distances, angles and such features
# resulting angles in degrees
# resulting distances in meters

module Ubiquity

  module Geoformulas

    extend self

    PI = Math::PI               # the infamous 3.1416...
    RAD_PER_DEG = PI/180.0      # PI/180 rad/deg
    EARTH_RADIUS = 6371009      # in m

    # DISTANCES

    # aproximacio a la distancia en metres per la formula de Haversine
    # (http://www.esawdust.com/blog/gps/files/HaversineFormulaInRuby.html)
    # (http://en.wikipedia.org/wiki/Earth_radius)
    def haversine_distance(lat1, lon1, lat2, lon2)
      dlon_rad = (lon2 - lon1) * RAD_PER_DEG
      dlat_rad = (lat2 - lat1) * RAD_PER_DEG
      lat1_rad = lat1 * RAD_PER_DEG
      lat2_rad = lat2 * RAD_PER_DEG

      a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
      c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))
      d = EARTH_RADIUS * c     # delta in meters
    end

    # aproximacio a la distancia en metres per la formula de Pitagoras en la que se
    # suposa que la terra es plana (valid fins a distancies de 20Km). L'error varia
    # depenent de la latitut
    # (http://cs.nyu.edu/visual/home/proj/tiger/gisfaq.html)
    def flatearth_distance(lat1, lon1, lat2, lon2)
      dlon_rad = (lon2 - lon1) * RAD_PER_DEG
      a = PI/2 - lat1 * RAD_PER_DEG
      b = PI/2 - lat2 * RAD_PER_DEG
      c = Math.sqrt( a**2 + b**2 - 2 * a * b * Math.cos(dlon_rad))
      d = EARTH_RADIUS * c
    end

    # aproximacio segons la llei esferica dels cosinus
    # (http://www.movable-type.co.uk/scripts/latlong.html)
    def slcosinus_distance(lat1, lon1, lat2, lon2)
      dlon_rad = (lon2 - lon1) * RAD_PER_DEG
      lat1_rad = lat1 * RAD_PER_DEG
      lat2_rad = lat2 * RAD_PER_DEG
      c = Math.acos(Math.sin(lat1_rad)*Math.sin(lat2_rad) +
          Math.cos(lat1_rad)*Math.cos(lat2_rad) * Math.cos(dlon_rad))
      d = EARTH_RADIUS * c
    end

    # aproximacio equirectangular. Only one trig function and a squared root.
    # (http://www.movable-type.co.uk/scripts/latlong.html)
    def equirectangular_distance(lat1, lon1, lat2, lon2)
      dlon = lon2 - lon1
      dlat = lat2 - lat1
      avlat_rad = (lat2 + lat1)/2 * RAD_PER_DEG

      x = dlon * Math.cos(avlat_rad)
      c = RAD_PER_DEG * Math.sqrt(x*x + dlat*dlat)
      d = EARTH_RADIUS * c
    end

    # distance is called from within Point and TrackSegment methods. It defaults
    # to equirectangular_distance but may be redefined as another.
    alias distance equirectangular_distance

    # correccio pitagorica per de la distancia en funció de les elevacions dels
    # punts inicial i final
    def pythagoric_distance_correction(dist, ele1, ele2)
      Math.sqrt(dist*dist + (ele2-ele1)**2) 
    end

    alias distance_correction pythagoric_distance_correction

    # BEARINGS

    # Angle inicial entre 2 posicions (l'angle canvia al seguir un gran cercle
    # u "orthodrome")
    # (http://www.movable-type.co.uk/scripts/latlong.html)
    def orthodrome_init_angle(lat1, lon1, lat2, lon2)
      dlon = (lon2 - lon1) * RAD_PER_DEG
      cola1 = Math.cos(lat1 * RAD_PER_DEG)
      sila1 = Math.sin(lat1 * RAD_PER_DEG)
      cola2 = Math.cos(lat2 * RAD_PER_DEG)
      sila2 = Math.sin(lat2 * RAD_PER_DEG)

      y = Math.sin(dlon) * cola2
      x = cola1 * sila2 - sila1 * cola2 * Math.cos(dlon)
      angle =  Math.atan2(y,x)/RAD_PER_DEG  # angle in degrees
    end

    # aproximacio a sac de l'angle entre 2 posicions. Valida per distancies
    # petites. Creada per mi mateix (MME)
    def equirectangular_angle(lat1, lon1, lat2, lon2)
      dlon = lon2 - lon1
      dlat = lat2 - lat1
      avlat_rad = (lat2 + lat1)/2 * RAD_PER_DEG

      x = dlon * Math.cos(avlat_rad)
      y = dlat
      angle =  Math.atan2(x,y)/RAD_PER_DEG  # angle in degrees
    end

    alias angle equirectangular_angle
    alias phase angle
    alias bearing angle

    # MIDPOINTS

    # Half way point between two points. Returns coordinates array
    # [lat, lon] of the mid point within a great cirle path
    # (shortest surface path)
    def orthodrome_midpoint(lat1, lon1, lat2, lon2)
      dlon = (lon2 - lon1) * RAD_PER_DEG
      cola1 = Math.cos(lat1 * RAD_PER_DEG)
      sila1 = Math.sin(lat1 * RAD_PER_DEG)
      cola2 = Math.cos(lat2 * RAD_PER_DEG)
      sila2 = Math.sin(lat2 * RAD_PER_DEG)
      x = cola2 * Math.cos(dlon)
      y = cola2 * Math.sin(dlon)

      lat = Math.atan2(sila1+sila2, Math.sqrt((cola1+x)**2 + y*y)) / RAD_PER_DEG
      lon = lon1 + Math.atan2(y,cola1+x) / RAD_PER_DEG

      [lat,lon]
    end

    alias midpoint orthodrome_midpoint

  end

end

