require 'liquid4-rails/version'
require 'liquid'
require 'kaminari'
require 'active_support/concern'

module Liquid
  module Rails
    autoload :TemplateHandler,  'liquid4-rails/template_handler'
    autoload :FileSystem,       'liquid4-rails/file_system'

    autoload :Drop,             'liquid4-rails/drops/drop'
    autoload :CollectionDrop,   'liquid4-rails/drops/collection_drop'

    def self.setup_drop(base)
      base.class_eval do
        include Liquid::Rails::Droppable
      end
    end
  end
end

require 'liquid4-rails/railtie' if defined?(Rails)
Dir[File.dirname(__FILE__) + '/liquid4-rails/{filters,tags,drops}/*.rb'].each { |f| require f }