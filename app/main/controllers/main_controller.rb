# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    model :store

    def index
      store._collapsed = true
    end

    def about
      # Add code for when the about view is loaded
    end

    def search_words
      NewWordTask.process_words(_sentence).then do |result|
        true
      end.fail do |error|
        puts "Error: #{error}"
      end
    end

    def collapse
      store._collapsed ^= true
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
