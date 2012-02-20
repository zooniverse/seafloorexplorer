require_relative 'extension_converter'
require 'coffee-script'

module Jekyll
  class CoffeeConverter < Converter
    def initialize(config)
      super

      config = config['coffee'] or {}
      @amd = config['amd'] || false
      @root = config['root'] || '.'
    end

    def matches(ext)
      ext =~ /\.coffee/i
    end

    def should_convert(file)
      path_match = File.absolute_path('.' + file.dir).start_with? File.absolute_path(@root)
      path_match and matches File.extname(file.name)
    end

    def convert(cs)
      if @amd
        cs = cs.split("\n")

        cs.map! do |line|
          "\t" + line
        end

        cs = cs.join("\n")

        cs = "define (require, exports, module) ->\n" + cs + "\n\treturn exports;"
      end

      CoffeeScript.compile(cs, :no_wrap => @amd)
    end

    def output_ext(ext)
      ".js"
    end
  end
end
