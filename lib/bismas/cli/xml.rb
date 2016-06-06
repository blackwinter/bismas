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

module Bismas

  class CLI

    class XML < self

      TYPES = %w[bismas solr]

      def self.defaults
        super.merge(type: TYPES.first)
      end

      def run(arguments)
        quit unless arguments.empty?

        if TYPES.include?(type = options[:type])
          Bismas.to_xml(options, &method(:quit))
        else
          unsupported_type(type)
        end
      end

      private

      def opts(opts)
        opts.summary_width = 34

        opts.option(:input__FILE, 'Path to input file [Default: STDIN]')

        opts.option(:output__FILE, 'Path to output file [Default: STDOUT]')

        opts.option(:schema__FILE, 'Path to schema file [Required]')

        input_options(opts)

        opts.separator
        opts.separator 'Output options:'

        type_option(opts)

        opts.separator

        opts.option(:output_encoding__ENCODING, :n, 'Output encoding')

        opts.separator

        opts.option(:mapping__FILE_OR_YAML, 'Path to mapping file or YAML string')

        opts.separator

        execute_options(opts)
      end

    end

  end

end
