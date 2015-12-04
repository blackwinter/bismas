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

    class XML < self

      def run(arguments)
        require_gem 'builder'

        quit unless arguments.empty?

        quit 'Schema file is required' unless schema_file = options[:schema]
        quit "No such file: #{schema_file}" unless File.readable?(schema_file)

        schema = Schema.parse_file(schema_file)

        reader_options = {
          encoding:        options[:encoding],
          key:             options[:key],
          strict:          options[:strict],
          silent:          options[:silent],
          category_length: schema.category_length
        }

        File.open_file(options[:output], {}, 'wb') { |f|
          xml = Builder::XmlMarkup.new(indent: 2, target: f)
          xml.instruct!

          xml.records(name: schema.name, description: schema.title) {
            Reader.parse_file(options[:input], reader_options) { |id, record|
              xml.record(id: id) {
                record.sort_by { |key,| key }.each { |key, values|
                  values.each { |value|
                    xml.field(value, name: key, description: schema[key])
                  }
                }
              }
            }
          }
        }
      end

      private

      def opts(opts)
        opts.option(:input__FILE, 'Path to input file [Default: STDIN]')

        opts.option(:output__FILE, 'Path to output file [Default: STDOUT]')

        opts.option(:schema__FILE, 'Path to schema file [Required]')

        opts.separator

        opts.option(:encoding__ENCODING, :N, "Input encoding [Default: #{DEFAULT_ENCODING}]")

        opts.separator

        opts.option(:key__KEY, :K, 'ID key of input file')

        opts.separator

        opts.switch(:strict, :S, 'Turn parse warnings into errors')

        opts.switch(:silent, :T, 'Silence parse warnings')
      end

    end

  end

end
