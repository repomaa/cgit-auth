require "base64"
require "openssl"

module Cgit::Auth
  module Crypt
    def decrypt(data)
      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      cipher.decrypt

      bytes = Base64.decode(data)
      iv = bytes[0, 12]
      ciphertext = bytes[iv.size, bytes.size - iv.size - 16]
      tag = bytes[iv.size + ciphertext.size, 16]

      buffer = IO::Memory.new
      buffer.write(cipher.update(ciphertext))
      cipher.tag = tag
      buffer.write(cipher.final)

      buffer.to_s
    end

    def encrypt(data)
      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      cipher.encrypt

      buffer = IO::Memory.new
      buffer.write(cipher.random_iv)
      buffer.write(cipher.update(data))
      buffer.write(cipher.final)
      buffer.write(cipher.tag)

      Base64.encode(buffer.to_slice)
    end

    extend self
  end
end
