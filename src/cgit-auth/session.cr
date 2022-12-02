require "./hmac_helpers"

module Cgit::Auth
  class Session
    extend HMACHelpers

    def self.deserialize(cookie : String)
      verify(cookie) do |data|
        expiry_date = Time.unix(data.read_bytes(Int64))
        username = data.gets_to_end

        new(username, expiry_date)
      end
    end

    getter user

    def initialize(@user : String, @expiry_date : Time = Time.utc + 1.month)
    end

    def expired?
      @expiry_date < Time.utc
    end

    def serialize
      self.class.sign do |io|
        io.write_bytes(@expiry_date.to_unix)
        io << user
      end
    end
  end
end
