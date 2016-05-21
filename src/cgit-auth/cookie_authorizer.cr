require "http"
require "./session"
require "./config"

module Cgit::Auth
  class CookieAuthorizer
    @cookie : HTTP::Cookie?

    def initialize(@repo : String, cookies)
      HTTP::Cookie::Parser.parse_cookies(cookies) do |cookie|
        next if cookie.name != Config.session_cookie_name
        @cookie = cookie
      end
    end

    def authorized?
      cookie = @cookie
      return false unless cookie
      session = Session.deserialize(cookie)
      return false if session.expired?

      can_read?(session.user)
    rescue OpenSSL::Cipher::Error
      false
    end

    protected def can_read?(user)
      system("gitolite", ["access", "-q", @repo, user, "R"])
      $? == 0
    end
  end
end
