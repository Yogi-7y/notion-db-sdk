## 0.8.0+2

- chore: Update README to add comparison with API. ([#18](https://github.com/Yogi-7y/notion-db-sdk/pull/18)

## 0.8.0+1

- chore: Update README and Doc strings. ([#17](https://github.com/Yogi-7y/notion-db-sdk/pull/17)

## 0.8.0

- feat: Introduce sorting. ([#16](https://github.com/Yogi-7y/notion-db-sdk/pull/16)

## 0.7.2

- fix: Add null check before passing in pagination params. ([#15](https://github.com/Yogi-7y/notion-db-sdk/pull/15))

## 0.7.1

- feat: use pagination params from `network_y` and remove the existing one's. ([#14](https://github.com/Yogi-7y/notion-db-sdk/pull/14))

## 0.7.0+2

- Bump `core_y` to latest version

## 0.7.0+1

- Bump `network_y` to latest version

## 0.7.0

- Add support for `updatePage`

## 0.6.0

- Return `Page` level data instead of directly returning properties.

## 0.5.0

- Introduce Pagination
- Introduce `fetchAll` method to fetch all pages from a database.

## 0.4.0

- Add caching support via `CacheMaager`

## 0.3.1

- Delete empty test file
- Remove dead imports

## 0.3.0

- Introduce new properties
  - `CreatedTime`
  - `LastEditedTime`
  - `Select`
- Introduce new filters
  - `CheckboxFilter`
  - `NumberFilter`
  - `DateFilter`
  - `TextFilter`

## 0.2.0

- Filter support

## 0.1.2

- Remove Flutter dependencies

## 0.1.1

- Fix analyzer issues.

## 0.1.0+2

- Update the GitHub URL in pubspec.yaml

## 0.1.0+1

- Update README with diagram link

## 0.1.0

Initial release of the Notion DB SDK package.

### Added

- Core functionality to interact with Notion databases
- Support for querying databases and fetching page properties
- Implementation of various Notion property types:
  - Text
  - Number
  - Checkbox
  - Date
  - Phone Number
  - Status
  - Relation
- Basic error handling and type-safe operations
- Comprehensive test suite for all major components
