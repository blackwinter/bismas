#--
###############################################################################
#                                                                             #
# bismas -- A Ruby client for BISMAS databases                                #
#                                                                             #
# Copyright (C) 2015 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# bismas is free software; you can redistribute it and/or modify it           #
# under the terms of the GNU Affero General Public License as published by    #
# the Free Software Foundation; either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# bismas is distributed in the hope that it will be useful, but               #
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY  #
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public      #
# License for more details.                                                   #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with bismas. If not, see <http://www.gnu.org/licenses/>.              #
#                                                                             #
###############################################################################
#++

module Bismas

  class Categories

    FIELD_RE = %r{\Afeld\s+=\s+(\d+)}i

    CATEGORY_RE = lambda { |category_length|
      %r{\A(.{#{category_length}})"(.+?)"} }

    def self.parse_file(file, options = {})
      Bismas.amend_encoding(options)

      categories, category_re = new, nil

      File.foreach(file, options) { |line|
        case line
          when FIELD_RE
            category_re = CATEGORY_RE[$1.to_i]
          when category_re
            categories[$1.strip] = $2.strip
        end
      }

      categories
    end

    def initialize
      @categories = {}
    end

    def categories
      @categories.keys
    end

    def [](key)
      @categories[key]
    end

    def []=(key, value)
      @categories[key] = value
    end

    def to_h
      @categories
    end

  end

end
