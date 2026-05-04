# Ransack::Mongoid REBORN

This gem contains the Mongoid support for Ransack.

The idea of this fork is to allow developers to upgrade their apps who have `Ransack:::Mongoid` as a dependency. You still should migrate away from it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ransack-mongoid', github: 'activerecord-hackery/ransack-mongoid'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ransack-mongoid

## Usage

Please refer to [Ransack's documentation](https://github.com/activerecord-hackery/ransack).

## Examples

Runnable scripts are in the `examples/` directory. Each one seeds a small
`Product` collection and demonstrates a feature area. Start MongoDB first:

```bash
docker compose up -d mongo
```

Then run any script with:

```bash
bundle exec ruby examples/01_basic_search.rb
```

| Script | What it covers |
|--------|---------------|
| `01_basic_search.rb` | `eq`, `cont`, `not_cont`, `start`, `end`, `ransack_alias` |
| `02_comparisons.rb` | `gt`, `lt`, `gteq`, `lteq`, boolean `eq`, `null`/`not_null` |
| `03_sorting.rb` | `s:` sort parameter, combined filter + sort |
| `04_groupings.rb` | AND/OR groupings, `m:` combinator, `_any`/`_all` suffixes |
| `05_scopes.rb` | `ransackable_scopes` whitelist, scope + filter chaining |

### Quick taste

```ruby
# Exact match
Product.search(category_eq: 'Electronics').result

# Case-insensitive contains
Product.search(name_cont: 'mouse').result

# Comparison + sort
Product.search(price_lteq: 50, s: 'rating desc').result

# OR grouping
Product.search(m: 'or', name_cont: 'desk', category_eq: 'Accessories').result

# Scope integration
Product.search(affordable: true, name_cont: 'mouse').result
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
