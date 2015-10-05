require_relative 'lib/bismas/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{bismas},
      version:      Bismas::VERSION,
      summary:      %q{A Ruby client for BISMAS databases.},
      description:  %q{Access BISMAS databases from Ruby.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: { cyclops: '~> 0.2', nuggets: '~> 1.4' },

      required_ruby_version: '>= 2.0'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
