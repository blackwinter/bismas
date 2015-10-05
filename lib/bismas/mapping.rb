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

  class Mapping

    DEFAULT_MAPPING = true

    LITERALS = { '~' => nil, 'false' => false, 'true' => true }

    NULL = Object.new.tap { |null| def null.apply(hash); hash; end }

    def self.[](mapping)
      mapping ? new(mapping) : NULL
    end

    def initialize(mapping)
      @mapping = default_hash.update(default: Array(DEFAULT_MAPPING))

      mapping.each { |key, value|
        value = Array(value.is_a?(String) ? range(value) : value)

        !key.is_a?(String) ? @mapping[key] = value :
          range(key) { |m| @mapping[m].concat(value) }
      }

      @mapping.each_value(&:uniq!)
    end

    def apply(hash, new_hash = default_hash)
      hash.each { |key, value| map(key) { |new_key|
        new_hash[new_key].concat(value)
      } }

      new_hash
    end

    def [](key)
      map(key).to_a
    end

    private

    def default_hash
      Hash.new { |h, k| h[k] = [] }
    end

    def range(list, &block)
      return enum_for(__method__, list) unless block

      list.split(/\s*,\s*/).each { |part|
        LITERALS.key?(part) ? block[LITERALS[part]] : begin
          from, to = part.split('-')
          from.upto(to || from, &block)
        end
      }
    end

    def fetch(key)
      @mapping.key?(key) ? @mapping[key] : @mapping[:default]
    end

    def map(key)
      return enum_for(__method__, key) unless block_given?

      fetch(key).each { |new_key|
        yield new_key == true ? key : new_key if new_key }
    end

  end

end
