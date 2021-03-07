require 'openssl'

module OnlineVoting
  # this classs is responsible for signing and blinding data
  # currently it makes use of RSA standard but it should be replaced in the future
  class RSABlindSigner
    def initialize(key)
      @key = key
      @n = key.params['n']
      @e = key.params['e']
      @d = key.params['d']
    end

    # == Parameters:
    # msg::
    #  Integer. Message to be signed
    # == Returns:
    # Integer. Signed message
    def sign(msg)
      msg.to_bn.mod_exp(@d, @n) % @n
    end


    # == Parameters:
    # message::
    #  String. Message to be blinded and signed
    # == Returns:
    # Array of 2 integers. First one is blinded message, the second is blinded signed message
    def blind_sign(message:)
      digest = OpenSSL::Digest::SHA224.hexdigest(message)

      msg_blinded = blind(digest)
      msg_int_blinded_signed = sign(msg_blinded)

      [msg_int_blinded, msg_int_blinded_signed]
    end


    # == Parameters:
    # signed::
    #  Integer. Signder messsage
    # message::
    #  Integer. Message to be verified
    # == Returns:
    # Boolean. True or false depending on whether the message is verified
    def verify(signed:, message:)
      message == (signed.to_bn.mod_exp(@e, @n) % @n)
    end

    def blind(msg, blinding_factor)
      msg_int = str_to_int(msg)

      msg_int * blinding_factor.to_bn.mod_exp(@e, @n) % @n
    end

    # blinding factor is a relatively prime to @n (public modulus of the RSA signature)
    def generate_blinding_factor
      n = @n.to_i

      r = (rand * (n - 1)).to_i
      r += 1 while r.gcd(n) != 1

      r
    end

    def unblind(msg, blinding_factor)
      msg * blinding_factor.to_bn.mod_inverse(@n) % @n
    end


    def str_to_int(str)
      self.class.str_to_int(str)
    end

    def int_to_str(int)
      self.class.int_to_str(int)
    end

    def self.int_to_str(int)
      [int.to_s(2).sub(/^1/, '')].pack('B*')
    end

    def self.str_to_int(str)
      ('1' + str.unpack('B*')[0]).to_i(2)
    end
  end
end
