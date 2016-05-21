require "base64"
require "openssl/cipher"
require "secure_random"
require "./config"

module Cgit::Auth
  module CryptHelpers
    CIPHER_NAME = "aes-256-gcm"

    def decrypt(cookie)
      cipher = self.cipher
      cipher.decrypt

      bytes = Base64.decode(cookie.value)
      iv = bytes[0, 12]
      cipher_string = bytes[iv.size, bytes.size - iv.size - 16]
      tag = bytes[iv.size + cipher_string.size, 16]

      cipher.iv = iv
      buffer = MemoryIO.new
      buffer.write(cipher.update(cipher_string))
      cipher.tag = tag
      buffer.write(cipher.final)

      buffer.to_slice
    end

    def encrypt(cookie)
      cipher = self.cipher
      cipher.decrypt

      buffer = MemoryIO.new

      buffer.write(cipher.random_iv)
      buffer.write(cipher.update(cookie))
      buffer.write(cipher.final)
      buffer.write(cipher.tag)

      Base64.encode(buffer.to_slice)
    end

    def cipher
      cipher = OpenSSL::Cipher.new(CIPHER_NAME)
      cipher.key = Config.cookie_secret
      cipher
    end
  end
end
