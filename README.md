<div align="center">

# asdf-octl [![Build](https://github.com/mgrechukh/asdf-octl/actions/workflows/build.yml/badge.svg)](https://github.com/mgrechukh/asdf-octl/actions/workflows/build.yml) [![Lint](https://github.com/mgrechukh/asdf-octl/actions/workflows/lint.yml/badge.svg)](https://github.com/mgrechukh/asdf-octl/actions/workflows/lint.yml)

[octl](https://github.com/outscale/octl) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add octl
# or
asdf plugin add octl https://github.com/mgrechukh/asdf-octl.git
```

octl:

```shell
# Show all installable versions
asdf list-all octl

# Install specific version
asdf install octl latest

# Set a version globally (on your ~/.tool-versions file)
asdf global octl latest

# Now octl commands are available
octl --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/mgrechukh/asdf-octl/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Mykola Grechukh-Lezhnov](https://github.com/mgrechukh/)
