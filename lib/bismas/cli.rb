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

require 'cyclops'
require 'bismas'

module Bismas

  class CLI < Cyclops

    def self.defaults
      super.merge(
        config: "#{name.split('::').last.downcase}.yaml",
        input:  '-',
        output: '-'
      )
    end

    def require_gem(*args)
      Bismas.require_gem(*args, &method(:abort))
    end

    def unsupported_type(type, types = self.class::TYPES)
      quit "Unsupported type: #{type}. Must be one of: #{types.join(', ')}."
    end

    def type_option(opts, types = self.class::TYPES)
      opts.option(:type__TYPE, "Output file type (#{types.join(', ')}) [Default: #{types.first}]")
    end

  end

end

require_relative 'cli/chardiff'
require_relative 'cli/filter'
require_relative 'cli/xml'
