require "base64"
require "openssl/hmac"

module Cgit::Auth
  module HMACHelpers
    class InvalidSignature < Exception; end

    def sign(&block : IO ->) : String
      io = IO::Memory.new.tap { |io| io.seek(32) }
      yield io
      data = io.to_slice

      signature = OpenSSL::HMAC.digest(
        OpenSSL::Algorithm::SHA256,
        Config.cookie_secret,
        data[32..-1]
      )

      signature.copy_to(data[0, 32])

      Base64.urlsafe_encode(data)
    end

    def verify(base64_data : String, &block : IO -> T): T forall T
      data = Base64.decode(base64_data)
      signature = data[0, 32]

      actual_signature = OpenSSL::HMAC.digest(
        OpenSSL::Algorithm::SHA256,
        Config.cookie_secret,
        data[32, data.size - 32],
      )

      raise InvalidSignature.new unless signature == actual_signature
      io = IO::Memory.new(data[32, data.size - 32])
      yield io
    end
  end
end
