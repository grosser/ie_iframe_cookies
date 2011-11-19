require 'action_pack'
require 'action_controller'

if ActionPack::VERSION::MAJOR > 2
  require 'action_dispatch/testing/test_process'

  ROUTES = ActionDispatch::Routing::RouteSet.new
  ROUTES.draw do
    match ':controller(/:action(/:id(.:format)))'
  end
  ROUTES.finalize!

  # funky patch to get @routes working, in 'setup' did not work
  module ActionController::TestCase::Behavior
    def process_with_routes(*args)
      @routes = ROUTES
      process_without_routes(*args)
    end
    alias_method_chain :process, :routes
  end

  class ActionController::Base
    self.view_paths = 'test/views'

    def self._routes
      ROUTES
    end
  end

  class ActionController::TestRequest
    def cookie_jar
      cookies
    end
  end
else
  require 'action_controller/test_process'
  ActionController::Routing::Routes.reload rescue nil
end

require 'test/unit'

$LOAD_PATH << 'lib'

# fake rails env for initialisation
# when Rails is defined, backtrace_cleaner is used, when assert fails
RAILS_ENV='development'

require "init"
