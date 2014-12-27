require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/rg'
require 'active_support/all'
require 'action_pack'
require 'action_controller'

ROUTES = ActionDispatch::Routing::RouteSet.new
ROUTES.draw do
  match ':controller(/:action(/:id(.:format)))', :via => :any
end
ROUTES.finalize!

# get routes working without having to mess in actual test
ActionController::TestCase.setup do
  @routes = ROUTES
end

# Rails 4.0 +
ActionController::Base.class_eval do
  def _routes
    ROUTES
  end
end

ActiveSupport.test_order = :random if ActiveSupport::VERSION::STRING >= "4.2.0"

require 'ie_iframe_cookies/version'
require 'ie_iframe_cookies'
