echo "Generating Database Schema"
pushd script/db
npm i
npm run create-table
popd