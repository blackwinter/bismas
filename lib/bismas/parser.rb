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

require 'strscan'

module Bismas

  # 0. Each _record_ is terminated by +0x0D+ +0x0A+ (<tt>CHARS[:newline]</tt>).
  # 0. Each _record_ starts with +0x01+ (<tt>CHARS[:rs]</tt>) or, if it's a
  #    deleted _record_, with +0xFF+ (<tt>CHARS[:deleted]</tt>).
  # 0. Each _field_ is terminated by +0x00+ (<tt>CHARS[:fs]</tt>).
  # 0. Each _field_ starts with the _category_ "number", a run of
  #    +category_length+ characters except +0x00+, +0x01+, +0xDB+ or +0xFF+;
  #    trailing space is stripped.
  # 0. The remaining characters of a _field_ form the _category_ content;
  #    trailing padding +0xDB+ (<tt>CHARS[:padding]</tt>) is stripped.
  #
  # To quote the BISMAS handbook: <i>"Konkret wird bei BISMAS jeder Datensatz
  # durch ASCII(1) eingeleitet. Es folgt die erste Kategorienummer mit dem
  # Kategorieinhalt. Abgeschlossen wird jede Kategorie mit ASCII(0), danach
  # folgt die nächste Kategorienummer und -inhalt usw. Der gesamte Datensatz
  # wird mit ASCII (13)(10) abgeschlossen."</i>

  class Parser

    # Legacy version of Parser that more closely mimics the behaviour of the
    # original BISMAS software. Deviations from Parser:
    #
    # 0. Records are not required to start with +0x01+, any character will do.
    # 0. Category numbers are extended to any character except +0x0D+ +0x0A+.
    # [NOT IMPLEMENTED YET]

    class Legacy < self

      def initialize(options = {})
        raise NotImplementedError, 'not implemented yet'

        @category_char = '.'
        super
        @regex[:category] = /#{@regex[:category]}(?<!#{@chars[:newline]})/
      end

      private

      def match_record
        @input.skip(/./)
      end

    end

    def self.parse(io, options = {}, &block)
      klass = options[:legacy] ? Legacy : self
      klass.new(options).parse(io, &block)
    end

    def initialize(options = {})
      @regex = Bismas.regex(options)

      @strict, @silent = options.values_at(:strict, :silent)
    end

    def parse(io, &block)
      @input = StringScanner.new('')

      io.each { |input|
        @input << input

        parse_record(&block) while @input.check_until(@regex[:newline])
        @input.string = @input.string.byteslice(@input.pos..-1)
      }

      error('Unexpected data') unless @input.eos?

      self
    end

    def parse_record
      if match(:deleted)
        match(:skip_line)
        return
      elsif !match_record
        error('Malformed record', :line)
        return
      end

      r = Hash.new { |h, k| h[k] = [] }
      parse_field  { |k, v| r[k] << v } until match(:newline)

      block_given? ? yield(r) : r
    end

    def parse_field
      k = match(:category, 0) and k.rstrip!

      v = match(:field, 1) or error(k ?
        "Unclosed field `#{k}'" : 'Unexpected data', :rest)

      k ? block_given? ? yield(k, v) : [k, v] :
        v.empty? ? nil : error('Malformed field', :field)
    end

    private

    def match(key, index = nil)
      res = @input.skip(@regex.fetch(key))
      res && index ? @input[index] : res
    end

    def match_record
      match(:rs)
    end

    def error(message, skip = nil)
      err = parse_error(message)
      raise err unless skip && !@strict

      warn err.to_s unless @silent
      match(:"skip_#{skip}")
      nil
    end

    def parse_error(message)
      ParseError.new(@input, message)
    end

    class ParseError < StandardError

      def initialize(input, message)
        @input, @message = input, message
      end

      def to_s
        '%s at %d:%d: %s' % [@message]
          .insert(*@input.eos? ?
            [0, 'Unexpected end of input'] :
            [-1, @input.peek(16).inspect])
          .insert(1, $., @input.pos)
      end

    end

  end

end
