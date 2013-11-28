require 'action_pack'

module ActionController
  class Base
    before_filter :normal_cookies_for_ie_in_iframes

    def normal_cookies_for_ie_in_iframes!
      if request.ie_iframe_cookies_browser_is_ie?
        normal_cookies_for_ie_in_iframes(:force => true)
        cookies["using_iframes_in_ie"] = true
      end
    end

    def normal_cookies_for_ie_in_iframes(options={})
      if request.normal_cookies_for_ie_in_iframes? or options[:force]
        headers['P3P'] = 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"'
        if request.get? or request.head?
          fresh_when :etag => rand(100_000_000) + 1, :last_modified => Time.now
        end
      end
    end
  end
end

if ActionPack::VERSION::MAJOR > 2
  request = ActionDispatch::Http::Cache::Request
  method = :module_eval
else
  request = ActionController::Request
  method = :class_eval
end

request.send(method) do
  def ie_iframe_cookies_browser_is_ie?
    agent = (env['HTTP_USER_AGENT'] || "")
    ["MSIE", "Trident"].detect { |ie| agent.include?(ie) }
  end

  def normal_cookies_for_ie_in_iframes?
    ie_iframe_cookies_browser_is_ie? and cookies["using_iframes_in_ie"]
  end

  alias_method :etag_matches_without_ie_iframe_cookies?, :etag_matches?
  def etag_matches?(*args)
    not normal_cookies_for_ie_in_iframes? and etag_matches_without_ie_iframe_cookies?(*args)
  end

  alias_method :not_modified_without_ie_iframe_cookies?, :not_modified?
  def not_modified?(*args)
    not normal_cookies_for_ie_in_iframes? and not_modified_without_ie_iframe_cookies?(*args)
  end
end
