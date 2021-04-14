# Tests

This directory keeps some files to facilitate the driver tests.

All tests uses a lua library named [faker](https://luarocks.org/modules/hectorvido/faker) and [Docker](https://www.docker.com/docker-community) to make this task a little bit easier.

## How to Use

Just execute the `test.lua`, this script will start two containers, one with the driver and another one with a MySQL database.

Without arguments it will test everything, but you can limit especifying a flag like `--ddl`:

```bash
lua test.lua
lua test.lua --ddl
```