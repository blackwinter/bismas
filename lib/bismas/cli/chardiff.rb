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

require 'csv'

module Bismas

  class CLI

    class Chardiff < self

      def self.defaults
        super.merge(
          file1_encoding:  DEFAULT_ENCODING,
          file2_encoding:  DEFAULT_ENCODING,
          output_encoding: Encoding.default_external
        )
      end

      def run(arguments)
        quit unless arguments.empty?

        output_encoding, frequencies = options[:output_encoding],
          Hash.new { |h, k| h[k] = Hash.new { |i, j| i[j] = [0, 0] } }

        2.times { |index|
          file = "file#{index + 1}"

          reader_options = {
            encoding: "#{options[:"#{file}_encoding"]}:#{output_encoding}",
            key: key = options[:"#{file}_key"]
          }

          Reader.parse_file(options[file.to_sym], reader_options) { |id, record|
            frequency = Hash.new(0); record.delete(key)

            record.each_value { |array| array.each { |value|
              value.each_char { |char| frequency[char] += 1 } } }

            frequencies.values_at(0, key ? id.to_i : $.).each { |hash|
              frequency.each { |char, count| hash[char][index] += count } }
          }
        }

        File.open_file(options[:output], {}, 'w') { |io|
          begin
            csv = CSV.new(io) << %w[id char count1 count2 diff]

            frequencies.sort_by { |id,| id }.each { |id, hash|
              hash.sort_by { |char,| char }.each { |char, (count1, count2)|
                unless count1 == count2
                  csv << [id, char, count1, count2, count2 - count1]
                end
              }
            }
          ensure
            csv.close if csv
          end
        }
      end

      private

      def opts(opts)
        opts.option(:file1__FILE, :i, 'Path to input file 1 [Required]')
        opts.option(:file2__FILE, :j, 'Path to input file 2 [Required]')

        opts.separator

        opts.option(:output__FILE, 'Path to output file [Default: STDOUT]')

        opts.separator
        opts.separator 'Input options:'

        opts.option(:file1_encoding__ENCODING, :N, "File 1 encoding [Default: #{DEFAULT_ENCODING}]")
        opts.option(:file2_encoding__ENCODING, :O, "File 2 encoding [Default: #{DEFAULT_ENCODING}]")

        opts.separator

        opts.option(:file1_key__KEY, :K, 'ID key of file 1')
        opts.option(:file2_key__KEY, :L, 'ID key of file 2')

        opts.separator
        opts.separator 'Output options:'

        opts.option(:output_encoding__ENCODING, :n, "Output encoding [Default: #{defaults[:output_encoding]}]")
      end

    end

  end

end
