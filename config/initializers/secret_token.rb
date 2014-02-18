# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Capistrano::Application.config.secret_key_base = 'bd39df95130d9b2644254e3d33f2424e96f9cc0564e375ffb67f6bbbb46943d31a41fd289af93bdcd83bae568681ff86defaf72679096d16caf3b84bf42605b8'
