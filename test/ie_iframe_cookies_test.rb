require 'test/test_helper'

class IETestController < ActionController::Base
  before_filter :normal_cookies_for_ie_in_iframes!, :only => :activate

  def activate
    render :text => 'OK'
  end

  def visit
    render :text => 'OK'
  end

  def with_etag
    if stale?(:etag => 'foo')
      render :text => 'OK'
    end
  end

  def with_modified
    if stale?(:last_modified => 1.minute.ago)
      render :text => 'OK'
    end
  end
end

class IEIFrameCookiesTest < ActionController::TestCase
  def setup
    @controller = IETestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def is_ok!
    assert_equal 'OK', @response.body
    assert_equal 200, @response.status.to_i
  end

  def is_not_modified!
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
    is_ok!
    assert_equal "true", cookies['using_iframes_in_ie']
  end

  test "does not set tracking cookie for nice users" do
    get :activate
    is_ok!
    assert_equal nil, cookies['using_iframes_in_ie']
  end

  # returning P3P headers
  test "it adds P3P headers for tracked IE users" do
    set_tracked
    set_ie
    get :visit
    is_ok!
    assert_equal 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"', @response.headers['P3P']
  end

  test "it does not add P3P headers for un-tracked IE users" do
    set_ie
    get :visit
    is_ok!
    assert_equal nil, @response.headers['P3P']
  end

  test "it does not add P3P headers for tracked nice users" do
    set_tracked
    get :visit
    is_ok!
    assert_equal nil, @response.headers['P3P']
  end

  # disable ETags 304
  test "is not modified for tracked nice users" do
    set_etag
    set_tracked
    get :with_etag
    is_not_modified!
  end

  test "is not modified for un-tracked ie users" do
    set_etag
    set_tracked
    get :with_etag
    is_not_modified!
  end

  test "is modified for tracked ie users" do
    set_etag
    set_tracked
    set_ie
    get :with_etag
    is_ok!
  end

  test "is not modified via modified since" do
    set_modified(0.minutes.ago)
    get :with_modified
    is_not_modified!
  end

  test "is modified via modified since" do
    set_modified(2.minutes.ago)
    get :with_modified
    is_ok!
  end

  test "is modified via modified since for tracked ie users" do
    set_tracked
    set_ie
    set_modified(0.minutes.ago)
    get :with_modified
    is_ok!
  end
end
