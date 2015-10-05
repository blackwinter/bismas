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

  class Reader < Base

    DEFAULT_IO = $stdin

    class << self

      def parse(*args, &block)
        reader = new(args.extract_options!).parse(*args, &block)
        block ? reader : reader.records
      end

      def parse_file(*args, &block)
        file_method(:parse, 'rb', *args, &block)
      end

    end

    attr_reader :records

    def reset
      super
      @records = {}
    end

    def parse(io = io(), &block)
      unless block
        records, block = @records, amend_block { |id, record|
          records[id] = record
        }
      end

      Parser.parse(io, @options) { |record|
        block[key ? record[key].join : auto_id.call, record] }

      self
    end

    private

    def amend_block(&block)
      return block unless $VERBOSE && k = @key

      r, i = block.binding.eval('_ = records, io')

      l = i.respond_to?(:lineno)
      s = i.respond_to?(:path) ? i.path :
        Object.instance_method(:inspect).bind(i).call

      lambda { |id, *args|
        if (r ||= block.binding.eval('records')).key?(id)
          warn "Duplicate record in #{s}#{":#{i.lineno}" if l}: »#{k}:#{id}«"
        end

        block[id, *args]
      }
    end

  end

end
