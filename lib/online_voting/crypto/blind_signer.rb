module OnlineVoting
  module Crypto
    class BlindSigner
      def sign(message:, key:)
        _sign(message, key)
      end

      def blind_sign(message:, key:)
        digest = OpenSSL::Digest::SHA224.hexdigest(message)

        # m' = mr^e (mod n)
        msg_int_blinded, r = blind(digest, key)
        msg_int_blinded_signed = _sign(msg_int_blinded, key)
        msg_int = text_to_int(digest)
        msg_int_signed = _sign(msg_int, key)

        [
          msg_int_blinded,
          msg_int_blinded_signed,
          r
        ]
      end

      def verify(signed:, message:, key:)
        _verify(signed, message, key)
      end

      def blind(msg, key)
        r = blinding_factor(key)
        msg_int = text_to_int(msg)
        # m' = mr^e (mod n)
        msg_int_blinded = msg_int * r.to_bn.mod_exp(key.params['e'], key.params['n']) % key.params['n']
        return msg_int_blinded, r
      end

      def blinding_factor(key)
        n = key.params['n'].to_i
        r = (rand*(n-1)).to_i
        # greatest common divisor
        r += 1 while r.gcd(n) !=1
        r
      end

      def text_to_int(text)
        bitmap = '1'+text.unpack('B*')[0]
        bitmap.to_i(2)
      end

      def int_to_text(int)
        bitmap = int.to_i.to_s(2)
        [bitmap.sub(/^1/, '')].pack('B*')
      end

      def unblind(blinded_msg, r, key)
        # sm = sm' * r^-1 (mod n)
        msg = blinded_msg * r.to_bn.mod_inverse(key.params['n']) % key.params['n']
        msg
      end

      def _sign(msg, key)
        # sm = m^d (mod n)
        msg.to_bn.mod_exp(key.params['d'], key.params['n']) % key.params['n']
      end

      def _verify(msg_signed, msg, key)
        # sm'^e (mod n) == m'
        verify_res = msg_signed.to_bn.mod_exp(key.params['e'], key.params['n']) % key.params['n']
        matches = verify_res == msg
      end
    end
  end
end
