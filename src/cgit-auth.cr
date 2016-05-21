require "./cgit-auth/*"

module Cgit::Auth
  def show_login_form(login_url, redirect_url)
    form = Form.new(login_url, redirect_url)
    form.to_s(STDOUT)
  end

  def authorized?(repo, cookie)
    authorizer = CookieAuthorizer.new(repo, cookie)
    authorizer.authorized?
  end

  def validate_form(login_url)
    validator = FormValidator.new(login_url, STDIN.gets_to_end)
    validator.respond(STDOUT)
  end

  extend self

  action, cookie, method, query, referer, path, host, https, repo, page, url, login_url = ARGV

  case action
  when "body"
    show_login_form(login_url, url)
  when "authenticate-cookie"
    exit(1) unless authorized?(repo, cookie)
  when "authenticate-post"
    validate_form(login_url)
  end
end
