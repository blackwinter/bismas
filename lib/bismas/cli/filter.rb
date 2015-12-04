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

  class CLI

    class Filter < self

      TYPES = %w[dat dbm]

      def self.defaults
        super.merge(
          type:       TYPES.first,
          key_format: '%s'
        )
      end

      def run(arguments)
        quit unless arguments.empty?

        klass = case type = options[:type]
          when 'dat'
            Writer
          when 'dbm'
            require_gem 'midos'
            options[:output_encoding] ||= Midos::DEFAULT_ENCODING
            Midos::Writer
          else
            quit "Unsupported type: #{type}. Must be one of: #{TYPES.join(', ')}."
        end

        Bismas.filter(klass, options, &method(:quit))
      end

      private

      def opts(opts)
        opts.option(:input__FILE, 'Path to input file [Default: STDIN]')

        opts.option(:output__FILE, 'Path to output file [Default: STDOUT]')

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

        opts.separator
        opts.separator 'Output options:'

        opts.option(:type__TYPE, "Output file type (#{TYPES.join(', ')}) [Default: #{TYPES.first}]")

        opts.separator

        opts.option(:output_encoding__ENCODING, :n, 'Output encoding [Default: depends on TYPE]')

        opts.separator

        opts.option(:output_key__KEY, :k, 'ID key of output file')
        opts.option(:key_format__KEY_FORMAT, :f, 'Key format [Default: %s]')

        opts.separator

        opts.option(:mapping__FILE_OR_YAML, 'Path to mapping file or YAML string')

        opts.separator

        opts.switch(:sort, 'Sort each record')

        opts.separator

        opts.option(:execute__CODE, 'Code to execute for each _record_ before mapping') { |e|
          options[:execute] << e
        }

        opts.option(:execute_mapped__CODE, :E, 'Code to execute for each _record_ after mapping') { |e|
          options[:execute_mapped] << e
        }

        opts.separator

        opts.option(:padding_length__LENGTH, :P, Integer, "Length of padding for TYPE=dat [Default: #{DEFAULT_PADDING_LENGTH}]")

        opts.separator
        opts.separator 'Common options:'

        opts.option(:category_length__LENGTH, :C, Integer, "Length of category for TYPE=dat [Default: #{DEFAULT_CATEGORY_LENGTH}]")
      end

    end

  end

end
