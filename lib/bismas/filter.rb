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
      execute = execute(options.values_at(*%i[execute execute_mapped]), &block)
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

      klass.open(options[:output], writer_options) { |writer|
        Reader.parse_file(options[:input], reader_options) { |id, record|
          execute[0][bind = binding]
          record = mapping.apply(encode(record, encoding))

          execute[1][bind]
          writer[key_format % id] = record
        }
      }
    end

  end

end
