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

require 'nuggets/file/open_file'
require 'nuggets/array/extract_options'

module Bismas

  class Base

    class << self

      private

      def file_method(method, mode, file, options = {}, *args, &block)
        Bismas.amend_encoding(options)

        File.open_file(file, options, mode) { |io|
          args.unshift(options.merge(io: io))
          method ? send(method, *args, &block) : block[new(*args)]
        }
      end

    end

    def initialize(options = {}, &block)
      self.key = options[:key]
      self.io  = options.fetch(:io, self.class::DEFAULT_IO)

      @auto_id_block = options.fetch(:auto_id, block)
      @options = options

      reset
    end

    attr_accessor :key, :io, :auto_id

    def reset
      @auto_id = @auto_id_block ? @auto_id_block.call : default_auto_id
    end

    private

    def default_auto_id(n = 0)
      lambda { n += 1 }
    end

  end

end
