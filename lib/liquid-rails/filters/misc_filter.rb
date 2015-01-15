require 'json'

module Liquid
  module Rails
    module MiscFilter
      # Get the nth element of the passed in array
      def index(array, position)
        array.at(position) if array.respond_to?(:at)
      end

      def random(input)
        rand(input.to_i)
      end

      def jsonify(object)
        JSON.dump(object)
      end

      # If condition is true, the class_name is returned. Otherwise, it returns nil.
      # class_name: css class name
      # condition: boolean
      def toggle_class_name(class_name, condition)
        condition ? class_name : nil
      end

      def default_pagination(paginate)
        html = []
        html << %(<span class="prev">#{link_to(paginate['previous']['title'], paginate['previous']['url'])}</span>) if paginate['previous']

        for part in paginate['parts']
          if part['is_link']
            html << %(<span class="page">#{link_to(part['title'], part['url'])}</span>)
          elsif part['title'].to_i == paginate['current_page'].to_i
            html << %(<span class="page current">#{part['title']}</span>)
          else
            html << %(<span class="deco">#{part['title']}</span>)
          end
        end

        html << %(<span class="next">#{link_to(paginate['next']['title'], paginate['next']['url'])}</span>) if paginate['next']
        html.join(' ')
      end

      def bootstrap_pagination(paginate, size="")
        html = []
        nav_ele = %{<nav><ul class="pagination #{size}">}
        html << nav_ele

        if paginate['previous']
          html << %(<li><a href="#{paginate['previous']['url']}" aria-label="Previous"><span aria-hidden="true"> #{paginate['previous']['title']}</span></a></li>)
        else
          html << %(<li class="disabled"><a href="#" aria-label="Previous"><span aria-hidden="true">&laquo; Previous</span></a></li>)
        end

        for part in paginate['parts']
          if part['is_link']
            html << %(<li><a href="#{part['url']}">#{part['title']}</a></li>)
          elsif  part['hellip_break']
            html << %(<li><a href="#">#{part['title']}</a></li>)
          else
            html << %(<li class="active"><a href="#">#{part['title']}</a></li>)
          end
        end

        if paginate['next']
          html << %(<li><a href="#{paginate['next']['url']}" aria-label="Next"><span aria-hidden="true">#{paginate['next']['title']}</span></a></li>)
        else
          html << %(<li class="disabled"><a href="#" aria-label="Next"><span aria-hidden="true">Next &raquo;</span></a></li>)
        end

        html << '</nav></ul>'
        html.join(' ')
      end
    end
  end
end

Liquid::Template.register_filter(Liquid::Rails::MiscFilter)