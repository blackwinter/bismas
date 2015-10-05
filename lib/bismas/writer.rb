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

require_relative 'parser'

module Bismas

  class Writer < Base

    DEFAULT_IO = $stdout

    class << self

      def write(*args, &block)
        new(args.extract_options!, &block).write(*args)
      end

      def write_file(*args, &block)
        file_method(:write, 'wb', *args, &block)
      end

      def open(*args, &block)
        file_method(nil, 'wb', *args, &block)
      end

    end

    def initialize(options = {})
      @category_length = options[:category_length] || DEFAULT_CATEGORY_LENGTH
      @padding_length  = options[:padding_length]  || DEFAULT_PADDING_LENGTH
      @sort            = options[:sort]

      @chars = Bismas.chars(options)

      super
    end

    def write(records, *args)
      !records.is_a?(Hash) ?
        records.each { |record| write_i(nil, record, *args) } :
        records.each { |id, record| write_i(id, record, *args) }

      self
    end

    def put(record, *args)
      record.is_a?(Hash) ?
        write_i(nil, record, *args) :
        write_i(*args.unshift(*record))

      self
    end

    alias_method :<<, :put

    def []=(id, record)
      write_i(id, record)
    end

    private

    def write_i(id, record, io = io())
      return if record.empty?

      category_format, fs = "%-#{@category_length}s", @chars[:fs]

      record[key] = id || auto_id.call if key && !record.key?(key)

      io << @chars[:rs]

      (@sort ? Hash[record.sort] : record).each { |k, v| Array(v).each { |w|
        io << category_format % k if k
        io << w.to_s << fs
      } if v }

      io << @chars[:padding] * @padding_length << fs if @padding_length > 0
      io << @chars[:newline]
    end

  end

end
