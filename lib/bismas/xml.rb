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

require 'time'

module Bismas

  module XML

    extend self

    extend Bismas

    def run(options, &block)
      block ||= method(:abort)

      require_gem 'builder'

      block['Schema file is required'] unless schema_file = options[:schema]
      block["No such file: #{schema_file}"] unless File.readable?(schema_file)

      schema = Schema.parse_file(schema_file)

      execute = execute(options.values_at(*%i[execute execute_mapped]), &block)
      mapping = mapping(options[:mapping], &block)

      records_attributes = {
        name:        schema.name,
        description: schema.title,
        mtime:       File.mtime(options[:input]).xmlschema
      }

      reader_options = {
        encoding:        options[:encoding],
        key:             options[:key],
        strict:          options[:strict],
        silent:          options[:silent],
        category_length: schema.category_length
      }

      schema = mapping.apply(schema)

      File.open_file(options[:output], {}, 'wb') { |f|
        xml = Builder::XmlMarkup.new(indent: 2, target: f)
        xml.instruct!

        xml.records(records_attributes) {
          Reader.parse_file(options[:input], reader_options) { |id, record|
            xml.record(id: id) {
              execute[0][bind = binding]
              record = mapping.apply(record)

              execute[1][bind]
              record.sort_by { |key,| key }.each { |key, values|
                field_attributes = {
                  name:        key,
                  description: Array(schema[key]).join('/')
                }

                Array(values).each { |value| xml.field(value, field_attributes) }
              }
            }
          }
        }
      }
    end

  end

end
