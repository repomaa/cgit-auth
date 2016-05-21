module Cgit::Auth
  module Config
    OPTIONS = {
      session_cookie_name: { type: String, default: "cgit_auth" }
      site_name: { type: String, default: "CGit" },
      login_label: { type: String, default: "Login" },
      login_failed_label: { type: String, default: "Login failed" },
      username_label: { type: String, default: "Username" },
      password_label: { type: String, default: "Password" },
      submit_label: { type: String, default: "Submit" },
      css_path: { type: String, default: "/cgit.css" },
      htpasswd_file: { type: String, default: "/home/git/htpasswd" },
      cookie_secret: { type: String },
    }

    {% for name, options in OPTIONS %}
      {% type = options[:type] %}
      def {{name.id}}{{(type ? " : #{type.id}" : "").id}}
        {% value = env(name.upcase) || options[:default] %}
        {{ type.stringify == "String" ? value : "#{type}.new(#{value})".id }}
      end
    {% end %}

    extend self
  end
end
