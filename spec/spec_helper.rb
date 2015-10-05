$:.unshift('lib') unless $:.first == 'lib'

require 'bismas'

RSpec.configure { |config|
  config.include(Module.new {
    def encode(*args)
      args.each { |s| s.force_encoding(Bismas::DEFAULT_ENCODING) }
    end

    def data(file)
      File.join(File.dirname(__FILE__), 'data', file)
    end
  })
}
