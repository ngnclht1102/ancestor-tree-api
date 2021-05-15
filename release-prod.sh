mix clean
source ./.env
rm -rf _build/prod/rel
mkdir _build/prod/rel
cd assets && yarn install && yarn run deploy
mix phx.digest
mix deps.get
mix compile
MIX_ENV=prod mix release
