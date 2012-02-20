module Jekyll
  class StaticFile
    attr_accessor :site, :name, :base, :dir
  end

  class Site
    alias_method :old_read, :read

    def read
      old_read

      static_files.select! do |file|
        should_be_page = @converters.any? do |converter|
          converter.should_convert file || false
        end

        if should_be_page
          pages << Page.new(file.site, file.base, file.dir, file.name)
        end

        not should_be_page
      end
    end
  end

  class Converter
    def should_convert(file)
      false
    end
  end
end
