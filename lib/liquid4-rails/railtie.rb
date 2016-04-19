module Liquid
  module Rails
    class Railtie < ::Rails::Railtie
      config.app_generators.template_engine :liquid

      initializer 'liquid4-rails.register_template_handler' do |app|
        ActiveSupport.on_load(:action_view) do
          ActionView::Template.register_template_handler(:liquid, Liquid::Rails::TemplateHandler)
        end
      end

      initializer 'liquid4-rails.include_partial' do |app|
        template_path = ::Rails.root.join('app/views')
        Liquid::Template.file_system = Liquid::Rails::FileSystem.new(template_path)
      end

      initializer 'liquid4-rails.setup_drop' do |app|
        [:active_record, :mongoid].each do |orm|
          ActiveSupport.on_load orm do
            Liquid::Rails.setup_drop self
          end
        end
      end
    end
  end
end