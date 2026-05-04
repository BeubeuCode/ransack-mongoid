# ransack-mongoid examples

Each script connects to MongoDB, seeds a small `Product` collection, and runs
a set of searches to demonstrate the gem's functionality.

## Prerequisites

MongoDB running on `localhost:27017` (or set `MONGODB_HOST`):

```bash
docker compose up -d mongo
```

## Running

```bash
# from the project root
bundle exec ruby examples/01_basic_search.rb
bundle exec ruby examples/02_comparisons.rb
bundle exec ruby examples/03_sorting.rb
bundle exec ruby examples/04_groupings.rb
bundle exec ruby examples/05_scopes.rb
```

Or run all at once:

```bash
for f in examples/0*.rb; do echo; echo ">>> $f"; bundle exec ruby "$f"; done
```

## What each script covers

| Script | Topics |
|--------|--------|
| `01_basic_search.rb` | `eq`, `cont`, `not_cont`, `start`, `end`, `ransack_alias` |
| `02_comparisons.rb` | `gt`, `lt`, `gteq`, `lteq`, boolean `eq`, `null`/`not_null` |
| `03_sorting.rb` | `s:` sort parameter, combined filter + sort |
| `04_groupings.rb` | AND/OR groupings, `m:` combinator, `_any`/`_all` suffixes |
| `05_scopes.rb` | `ransackable_scopes` whitelist, scope + filter chaining |

## Sample data

10 products across Electronics, Furniture, and Accessories categories,
with name, price, rating, in-stock flag, and a brand association.
