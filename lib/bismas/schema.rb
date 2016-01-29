#--
###############################################################################
#                                                                             #
# bismas -- A Ruby client for BISMAS databases                                #
#                                                                             #
# Copyright (C) 2015-2016 Jens Wille                                          #
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

require 'forwardable'

module Bismas

  class Schema

    include Enumerable

    extend Forwardable

    FIELD_RE = %r{\Afeld\s+=\s+(\d+)}i

    CATEGORY_RE = lambda { |category_length|
      %r{\A(.{#{category_length}})"(.+?)"} }

    class << self

      def parse(*args)
        new.parse(*args)
      end

      def parse_file(file, options = {})
        Bismas.amend_encoding(options)
        File.open(file, 'rb', options, &method(:parse))
      end

    end

    def initialize
      @title, @name, @category_length, @categories = nil, nil, nil, {}
    end

    attr_accessor :title, :name, :category_length

    def_delegators :@categories, :[], :[]=, :each

    def_delegator :@categories, :keys, :categories

    def parse(io)
      category_re = nil

      io.each { |line|
        case line
          when category_re
            self[$1.strip] = $2.strip
          when FIELD_RE
            category_re = CATEGORY_RE[
              self.category_length = $1.to_i]
          when String
            title ? name ? nil :
              self.name  = line.strip :
              self.title = line.strip
        end
      }

      self
    end

  end

end
