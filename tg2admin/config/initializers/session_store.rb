# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tg2admin_session',
  :secret      => '9200894931bbc505455b79c9d295eb635c88a2b6ee1a5680d67d558982f405adb2e35742884d8b2f4762b2ac05ddc20634a58a7224225935a56091d7d329d7c9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
