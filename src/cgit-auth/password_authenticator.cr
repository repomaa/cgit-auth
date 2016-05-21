require "./session"
require "./config"

module Cgit::Auth
  class PasswordAuthenticator
    def initialize(@username : String, @password : String)
    end

    def authenticated?
      Process.run("htpasswd", ["-v", Config.htpasswd_file, @username]) do |pipe|
        unless pipe.input.closed?
          pipe.input.puts(@password)
        end
      end

      $?.success?
    end
  end
end
