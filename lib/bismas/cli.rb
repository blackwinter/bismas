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

    def input_options(opts)
      opts.separator
      opts.separator 'Input options:'

      opts.option(:input_encoding__ENCODING, :N, "Input encoding [Default: #{DEFAULT_ENCODING}]")

      opts.separator

      opts.option(:input_key__KEY, :K, 'ID key of input file')

      opts.separator

      opts.switch(:strict, :S, 'Turn parse warnings into errors')

      opts.switch(:silent, :T, 'Silence parse warnings')

      opts.separator

      opts.switch(:legacy, :L, 'Use the legacy parser')
    end

    def type_option(opts, types = self.class::TYPES)
      opts.option(:type__TYPE, "Output file type (#{types.join(', ')}) [Default: #{types.first}]")
    end

    def execute_options(opts)
      opts.option(:execute__FILE_OR_CODE, 'Code to execute for each _record_ before mapping') { |e|
        (options[:execute] ||= []) << e
      }

      opts.option(:execute_mapped__FILE_OR_CODE, :E, 'Code to execute for each _record_ after mapping') { |e|
        (options[:execute_mapped] ||= []) << e
      }

      opts.separator

      opts.option(:execute_before__FILE_OR_CODE, :B, 'Code to execute before processing records') { |e|
        (options[:execute_before] ||= []) << e
      }

      opts.option(:execute_after__FILE_OR_CODE, :A, 'Code to execute after processing records') { |e|
        (options[:execute_after] ||= []) << e
      }
    end

  end

end

require_relative 'cli/chardiff'
require_relative 'cli/filter'
require_relative 'cli/xml'
