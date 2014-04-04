# it's only a version number

module Ubiquity

  module Version

    MAJOR = 0
    MINOR = 0
    PATCH = 1
    BUILD = 0  # use nil if not used
	
    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join(".")

  end

end
