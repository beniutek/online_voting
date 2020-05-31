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
  encrypted_message = cipher.update(message) + cipher.final

  encoded_encrypted_message = Base64.encode64(encrypted_message)

  puts "Message: #{message}"
  puts "MSG: #{encrypted_message}"

  blinded_encoded_encrypted_message, r = rsa.blind(encoded_encrypted_message, akey.public_key)
  signed_blinded_encoded_encrypted_message = rsa._sign(blinded_encoded_encrypted_message, vkey)

  puts "\nblinded: "
  puts blinded_encoded_encrypted_message

  puts "\nblinded signed: "
  puts signed_blinded_encoded_encrypted_message
  signed_by_admin_blinded_encoded_encrypted_message = nil

  if rsa.verify(signed: signed_blinded_encoded_encrypted_message, message: blinded_encoded_encrypted_message, key: vkey.public_key)
    puts "\nMESSAGE IS OK"

    signed_by_admin_blinded_encoded_encrypted_message = rsa._sign(blinded_encoded_encrypted_message, akey)

    if rsa.verify(signed: signed_by_admin_blinded_encoded_encrypted_message, message: blinded_encoded_encrypted_message, key: akey.public_key)
      puts "\nADMIN MESSAGE IS OK"

      signed_by_admin_encoded_encrypted_message = rsa.unblind(signed_by_admin_blinded_encoded_encrypted_message, r, akey.public_key)

      puts "\nUNBLINDED: "
      puts signed_by_admin_encoded_encrypted_message

      msg_int = rsa.text_to_int(encoded_encrypted_message)

      if rsa.verify(signed: signed_by_admin_encoded_encrypted_message, message: msg_int, key: akey.public_key)
        puts "\nUNLINDED SIGNED VERIFIED!"
        puts "GOOD JOB!"
        decoded64 = Base64.decode64(encoded_encrypted_message)
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
        puts "signed by admin and unlbinded: #{signed_by_admin_encoded_encrypted_message}"
        puts "message: #{msg_int}"
      end
    else
      puts "\nFAILED TO VERIGY SIGNED BY ADMIN MESSAGE"
    end
  else
    puts "\nFAILED TO VERIFY BLINDED SIGNED MESSAGE WITH VKEY"
  end
end
