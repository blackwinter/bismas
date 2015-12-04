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

  # Default file encoding
  DEFAULT_ENCODING = 'CP850'

  CHARS = { rs: 1, deleted: 255, padding: 219, fs: 0, newline: "\r\n" }

  REGEX = Hash[CHARS.keys.map { |k| [k, "%{#{k}}"] }].update(
    field:      '(.*?)%{padding}*%{fs}',
    skip_rest:  '.*?(?=%{newline})',
    skip_line:  '.*?%{newline}',
    skip_field: '.*?%{fs}'
  )

  CATEGORY_CHAR_SKIP = %i[rs deleted padding fs].each { |k|
    CHARS[k] = CHARS[k].chr.force_encoding(DEFAULT_ENCODING) }

  # See parameter +FELD+ in BISMAS <tt>*.CAT</tt>
  DEFAULT_CATEGORY_LENGTH = 4

  # See parameter +FUELLZEICHEN+ in BISMAS <tt>*.CFG</tt>
  DEFAULT_PADDING_LENGTH = 20

  class << self

    def chars(options = {})
      encoding = amend_encoding(options).split(':').last

      Hash[CHARS.map { |k, v| [k, begin
        v.encode(encoding)
      rescue Encoding::UndefinedConversionError
        v.dup.force_encoding(encoding)
      end] }]
    end

    def regex(options = {}, chars = chars(options))
      category_length = options[:category_length] || DEFAULT_CATEGORY_LENGTH

      Hash[REGEX.map { |k, v| [k, Regexp.new(v % chars)] }].update(category:
        /[^#{chars.values_at(*CATEGORY_CHAR_SKIP).join}]{#{category_length}}/)
    end

    def filter(klass, options, &block)
      execute = %i[execute execute_mapped].map { |key|
        value = Array(options[key]); lambda { |bind|
        value.each { |code| eval(code, bind) } } }

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

    def mapping(mapping, &block)
      block ||= method(:abort)

      Mapping[case mapping
        when nil, Hash    then mapping
        when /\A\{.*\}\z/ then SafeYAML.load(mapping)
        when String       then File.readable?(mapping) ?
          SafeYAML.load_file(mapping) : block["No such file: #{mapping}"]
        else block["Invalid mapping: #{mapping.inspect}"]
      end]
    end

    def encode(record, encoding)
      return record unless encoding

      fallback = Hash.new { |h, k| h[k] = '?' }

      record.each { |key, values|
        values.each { |value| value.encode!(encoding, fallback: fallback) }

        unless fallback.empty?
          chars = fallback.keys.map(&:inspect).join(', '); fallback.clear
          warn "Undefined characters at #{$.}:#{key}: #{chars}"
        end
      }
    end

    def amend_encoding(options, default_encoding = DEFAULT_ENCODING)
      encoding = (options[:encoding] || default_encoding).to_s

      options[:encoding] = encoding.start_with?(':') ?
        default_encoding.to_s + encoding : encoding
    end

  end

end

require_relative 'bismas/base'
require_relative 'bismas/schema'
require_relative 'bismas/reader'
require_relative 'bismas/writer'
require_relative 'bismas/mapping'
require_relative 'bismas/version'
