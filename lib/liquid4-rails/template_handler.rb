module Liquid
  module Rails
    class TemplateHandler

      def self.call(template)
        "Liquid::Rails::TemplateHandler.new(self).render(#{template.source.inspect}, local_assigns)"
      end

      def initialize(view)
        @view       = view
        @controller = @view.controller
        @helper     = ActionController::Base.helpers
      end

      def render(template, local_assigns={})
        @view.controller.headers['Content-Type'] ||= 'text/html; charset=utf-8'

        assigns = if @controller.respond_to?(:liquid_assigns, true)
          @controller.send(:liquid_assigns)
        else
          @view.assigns
        end
        assigns['content_for_layout'] = @view.content_for(:layout) if @view.content_for?(:layout)
        assigns.merge!(local_assigns.stringify_keys)

        debug_mode = ::Rails.env.development? || ::Rails.env.test?
        if debug_mode
          Liquid.cache_classes = false
          Liquid::Template.error_mode = :strict
        end

        liquid = Liquid::Template.parse(template)
        liquid.send(debug_mode ? :render! : :render, assigns, filters: filters, registers: { view: @view, controller: @controller, helper: @helper }, strict_variables: debug_mode, strict_filters: debug_mode).html_safe
      end

      def filters
        if @controller.respond_to?(:liquid_filters, true)
          @controller.send(:liquid_filters)
        else
          [@controller._helpers]
        end
      end

      def compilable?
        false
      end
    end
  end
end
