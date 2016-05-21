require "ecr/macros"
require "./config"

module Cgit::Auth
  class Form
    record Labels,
      site_name : String,
      login : String,
      login_failed : String,
      username : String,
      password : String,
      submit : String

    def initialize(@login_url : String, @redirect_url : String, @failed = false)
      @css_path = Config.css_path
      @site_name = Config.site_name

      @labels = Labels.new(
        Config.site_name,
        Config.login_label,
        Config.login_failed_label,
        Config.username_label,
        Config.password_label,
        Config.submit_label
      )
    end

    ECR.def_to_s "templates/login_form.ecr"
  end
end
