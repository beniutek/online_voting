def foo
  message = "hello world!"

  vkey = OpenSSL::PKey::RSA.new(512)
  akey = OpenSSL::PKey::RSA.new(512)

  rsa = OnlineVoting::RSABlindSigner.new
  # msg = OpenSSL::Digest::SHA224.hexdigest(message)
  cipher = OpenSSL::Cipher::AES256.new :CBC
  cipher.encrypt
  iv = cipher.random_iv
  key = SecureRandom.hex(16)
  cipher.key = key
  encrypted_text = cipher.update(message) + cipher.final

  msg = Base64.encode64(encrypted_text)

  puts "Message: #{message}"
  puts "MSG: #{msg}"

  blinded, r = rsa.blind(msg, akey.public_key)
  blinded_signed = rsa._sign(blinded, vkey)

  puts "\nblinded: "
  puts blinded

  puts "\nblinded signed: "
  puts blinded_signed
  signed_by_a = nil

  if rsa.verify(signed: blinded_signed, message: blinded, key: vkey.public_key)
    puts "MESSAGE IS OK"

    signed_by_a = rsa._sign(blinded, akey)

    if rsa.verify(signed: signed_by_a, message: blinded, key: akey.public_key)
      puts "ADMIN MESSAGE IS OK"

      signed_by_a_unblinded = rsa.unblind(signed_by_a, r, akey.public_key)

      puts "\nUNBLINDED: "
      puts signed_by_a_unblinded

      msg_int = rsa.text_to_int(msg)
      if rsa.verify(signed: signed_by_a_unblinded, message: msg_int, key: akey.public_key)
        puts "UNLINDED SIGNED VERIFIED!"
        puts "GOOD JOB!"
        decoded64 = Base64.decode64(msg)
        decipher = OpenSSL::Cipher::AES256.new :CBC
        decipher.decrypt
        decipher.iv = iv
        decipher.key = key
        plain_text = decipher.update(decoded64) + decipher.final
        puts "============================"
        puts plain_text
        puts "============================"
        puts "\nFIN"
      else
        puts "\nFAILED TO VERIFY SIGNED BY ADMIN UNLBINDED"
        puts "signed by admin and unlbinded: #{signed_by_a_unblinded}"
        puts "message: #{msg_int}"
      end
    else
      puts "FAILED TO VERIGY SIGNED BY ADMIN MESSAGE"
    end
  else
    puts "FAILED TO VERIFY BLINDED SIGNED MESSAGE WITH VKEY"
  end
end
