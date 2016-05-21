require "./crypt_helpers"

module Cgit::Auth
  class Session
    extend CryptHelpers

    def self.deserialize(cookie)
      plain_cookie = decrypt(cookie)
      expiry_date_bytes = plain_cookie[0, 8]
      username_bytes = plain_cookie[8, plain_cookie.size - 8]

      expiry_epoch = (expiry_date_bytes.pointer(expiry_date_bytes.size) as Int64*).value
      username = String.new(username_bytes)
      expiry_date = Time.epoch(expiry_epoch)

      new(username, expiry_date)
    end

    getter user

    def initialize(@user : String, @expiry_date : Time = Time.now + 1.month)
    end

    def expired?
      @expiry_date < Time.now
    end

    def serialize
      buffer = MemoryIO.new
      expiry_epoch = @expiry_date.epoch

      expiry_slice = Slice(UInt8).new(pointerof(expiry_epoch) as UInt8*, 8)
      username_slice = @user.to_slice

      buffer.write(expiry_slice)
      buffer.write(username_slice)

      self.class.encrypt(buffer.to_slice)
    end
  end
end
