mix clean
source .env
mix compile
MIX_ENV=prod mix release
