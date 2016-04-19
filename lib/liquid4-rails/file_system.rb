require 'liquid/file_system'

module Liquid
  module Rails
    class FileSystem < ::Liquid::LocalFileSystem
      def read_template_file(template_path)
        super
      end
    end
  end
end
