# hero-action

[![testing](https://github.com/unfor19/hero-action/workflows/testing/badge.svg)](https://github.com/unfor19/hero-action/actions?query=workflow%3Atesting)
[![test-action](https://github.com/unfor19/hero-action-test/workflows/test-action/badge.svg)](https://github.com/unfor19/hero-action-test/actions?query=workflow%3Atest-action)


All-in-one action to develop and maintain GitHub Actions.

Tested in [unfor19/hero-action-test](https://github.com/unfor19/hero-action-test/actions?query=workflow%3Atest-action)

## How It Works

...

## Requirements

...

## Usage

```yaml
name: Update README.md
on:
  push:

jobs:
# ...
```

### Help Menu

```bash
./entrypoint.sh --help
```

<!-- help_menu_start -->

```bash
Help menu is injected here
```
<!-- help_menu_end -->

_NOTE_: the code block above :point_up: was automatically generated with replacer! See the raw version of this [README.md](https://raw.githubusercontent.com/unfor19/hero-action/master/README.md) file

## Contributing

Report issues/questions/feature requests on the [Issues](https://github.com/unfor19/hero-action/issues) section.

Pull requests are welcome! These are the steps:

1. Fork this repo
1. Create your feature branch from master
   ```bash
   git checkout -b my-new-feature
   ```
2. Build development image
   ```bash
   docker build -t "hero-action:dev" --target "dev" .
   ```
3. Run development image
   ```bash
   docker run --rm -it -v "$PWD":"/code" --workdir "/code" "hero-action:dev"
   ```
4. Add the code of your new feature
5. Run tests on your code, feel free to add more tests
   ```bash
   # in container
   ./tests/test.sh
   ... # All good? Move on to the next step
   ```
6. Commit your remarkable changes
   ```bash
   git commit -am 'Added new feature'
   ```
7. Push to the branch
   ```bash
   git push --set-up-stream origin my-new-feature
   ```
8. Create a new Pull Request and provide details about your changes

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/hero-action/blob/master/LICENSE) file for details
