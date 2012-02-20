require_relative 'extension_converter'
require 'sass'

module Jekyll
  class SassConverter < Converter
    def initialize(config)
      super

      config = config['sass'] || {}
      @syntax = config['syntax'] || 'scss'
      @syntax = @syntax.to_sym
      @paths = config['paths'] or ['.']
    end

    def matches(ext)
      ext =~ /\.#{@syntax}/i
    end

    def should_convert(file)
      paths_match = @paths.any? do |path|
        File.absolute_path('.' + file.dir).start_with? File.absolute_path(path)
      end

      paths_match and matches File.extname(file.name)
    end

    def convert(sass)
      begin
        Sass::Engine.new(sass, :syntax => @syntax, :load_paths => @paths).render
      rescue Sass::SyntaxError => error
        puts '', '* ' * 40, error, '* ' * 40, ''
      end
    end

    def output_ext(ext)
      '.css'
    end
  end
end
