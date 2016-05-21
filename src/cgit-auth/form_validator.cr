require "http"
require "./password_authenticator"

module Cgit::Auth
  class FormValidator
    @username : String?
    @password : String?

    def initialize(@login_url : String, body : String)
      params = HTTP::Params.parse(body)
      @username = params["username"]?
      @password = params["password"]?
      @redirect_url = params["redirect_url"]? || "/"
    end

    def respond(io)
      response = HTTP::Server::Response.new(io)
      if authenticated?
        session = Session.new(@username.not_nil!)
        response.cookies[Config.session_cookie_name] = session.serialize
        response.status_code = 303
        response.headers["Location"] = @redirect_url
      else
        response.status_code = 403
        form = Form.new(@login_url, @redirect_url, failed: true)
        form.to_s(response)
      end

      response.close
    end

    private def authenticated?
      username = @username
      password = @password
      return false unless username && password

      authenticator = PasswordAuthenticator.new(username, password)
      authenticator.authenticated?
    end
  end
end
