# coding: UTF-8

require 'gatling_gun'

if Rails.env.production?
  SENDGRID_NEWSLETTERS = GatlingGun.new(ENV_CONFIG['SENDGRID_USER_NAME'], ENV_CONFIG['SENDGRID_PASSWORD'])
else
  SENDGRID_NEWSLETTERS = GatlingGun.new('fake_user', 'fake_password')
end
