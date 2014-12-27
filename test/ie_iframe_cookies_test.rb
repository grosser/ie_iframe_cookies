require File.expand_path('../test_helper', __FILE__)

class IETestController < ActionController::Base
  before_filter :normal_cookies_for_ie_in_iframes!, :only => :activate

  def activate
    render :text => 'OK'
  end

  def visit
    render :text => 'OK'
  end

  def with_etag
    options = {:etag => 'foo'}
    options[:template] = false if ActiveSupport::VERSION::STRING >= "4.2.0" # ignore template etagger
    render :text => 'OK' if stale?(options)
  end

  def with_modified
    if stale?(:last_modified => 1.minute.ago)
      render :text => 'OK'
    end
  end
end

class IEIFrameCookiesTest < ActionController::TestCase
  tests IETestController

  DEFAULT_ETAG = ActionPack::VERSION::MAJOR > 2 ? nil : '"e0aa021e21dddbd6d8cecec71e9cf564"'

  setup do
    @request = ActionController::TestRequest.new
  end

  def assert_is_ok!
    assert_equal 'OK', @response.body
    assert_equal 200, @response.status.to_i
  end

  def assert_is_not_modified!
    assert_equal 304, @response.status.to_i
  end

  def set_ie
    @request.env['HTTP_USER_AGENT'] = 'Mr. MSIE is coming...'
  end

  def set_tracked
    @request.cookies['using_iframes_in_ie'] = 'true'
  end

  def set_etag
    @request.env['HTTP_IF_NONE_MATCH'] = '"acbd18db4cc2f85cedef654fccc4a4d8"'
  end

  def set_modified(time)
    @request.env['HTTP_IF_MODIFIED_SINCE'] = time.rfc2822
  end

  test "it has a VERSION" do
    assert_match /^\d+\.\d+\.\d+$/, IEIframeCookies::VERSION
  end

  # adding tracking cookie
  test "it sets tracking cookie for IE users" do
    set_ie
    get :activate
    assert_is_ok!
    assert_equal "true", cookies['using_iframes_in_ie'].to_s
  end

  test "it sets tracking cookie for IE11" do
    @request.env['HTTP_USER_AGENT'] = "Some Trident thingy"
    get :activate
    assert_is_ok!
    assert_equal "true", cookies['using_iframes_in_ie'].to_s
  end

  test "does not set tracking cookie for nice users" do
    get :activate
    assert_is_ok!
    assert_equal nil, cookies['using_iframes_in_ie']
  end

  # etag for get requests to trick rack::conditionalget
  test "it adds a always-fresh ETAG for tracked IE users on get, so rack thinks its fresh" do
    set_tracked
    set_ie
    get :visit
    assert_is_ok!
    old = @response.headers['ETag']

    get :visit
    assert_is_ok!
    assert_not_equal old, @response.headers['ETag']
  end

  test "it does not add an etag if the request is not get" do
    set_tracked
    set_ie
    post :visit
    assert_is_ok!
    assert_equal DEFAULT_ETAG, @response.headers['ETag']
  end

  test "it does not add an etag if non ie" do
    set_tracked
    get :visit
    assert_is_ok!
    assert_equal DEFAULT_ETAG, @response.headers['ETag']
  end

  test "it does not add an etag if not tracked" do
    set_ie
    get :visit
    assert_is_ok!
    assert_equal DEFAULT_ETAG, @response.headers['ETag']
  end

  # returning P3P headers
  test "it adds P3P headers for tracked IE users" do
    set_tracked
    set_ie
    get :visit
    assert_is_ok!
    assert_equal 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"', @response.headers['P3P']
  end

  test "it does not add P3P headers for un-tracked IE users" do
    set_ie
    get :visit
    assert_is_ok!
    assert_equal nil, @response.headers['P3P']
  end

  test "it does not add P3P headers for tracked nice users" do
    set_tracked
    get :visit
    assert_is_ok!
    assert_equal nil, @response.headers['P3P']
  end

  # disable ETags 304
  test "is not modified for tracked nice users" do
    set_etag
    set_tracked
    get :with_etag
    assert_is_not_modified!
  end

  test "is not modified for un-tracked ie users" do
    set_etag
    set_tracked
    get :with_etag
    assert_is_not_modified!
  end

  test "is modified for tracked ie users" do
    set_etag
    set_tracked
    set_ie
    get :with_etag
    assert_is_ok!
  end

  test "is not modified via modified since" do
    set_modified(0.minutes.ago)
    get :with_modified
    assert_is_not_modified!
  end

  test "is modified via modified since" do
    set_modified(2.minutes.ago)
    get :with_modified
    assert_is_ok!
  end

  test "is modified via modified since for tracked ie users" do
    set_tracked
    set_ie
    set_modified(Time.now)
    get :with_modified
    assert_is_ok!
  end
end
