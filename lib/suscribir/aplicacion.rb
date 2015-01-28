def tokeniza_email(email)
  Digest::SHA1.hexdigest("tokeniza_email_#{ Rails.application.secrets.esta_web_secret_token }_#{ email }")
end
