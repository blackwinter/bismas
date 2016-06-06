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

  module Filter

    extend self

    extend Bismas

    def run(klass, options, &block)
      execute = execute_options(options, &block)
      mapping = mapping(options[:mapping], &block)

      key_format = options[:key_format]

      writer_options = {
        encoding:        encoding = options[:output_encoding],
        key:             options[:output_key],
        sort:            options[:sort],
        padding_length:  options[:padding_length],
        category_length: options[:category_length]
      }

      reader_options = {
        encoding:        options[:input_encoding],
        key:             options[:input_key],
        strict:          options[:strict],
        silent:          options[:silent],
        legacy:          options[:legacy],
        category_length: options[:category_length]
      }

      execute[0][bind1 = binding]

      klass.open(options[:output], writer_options) { |writer|
        Reader.parse_file(options[:input], reader_options) { |id, record|
          execute[1][bind2 = binding]
          record = mapping.apply(encode(record, encoding))

          execute[2][bind2]
          writer[key_format % id] = record
        }
      }

      execute[3][bind1]
    end

  end

end
