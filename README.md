# homebrew-tap

Homebrew formulae for [mhrsntrk](https://github.com/mhrsntrk)'s tools.

```sh
brew install mhrsntrk/tap/landline
```

## landline

The host daemon for [Landline](https://github.com/mhrsntrk/landline): a terminal
on your iPhone, reaching machines you own over your own Tailscale tailnet.

After installing:

```sh
landlined install
tailscale serve --bg --https=443 http://127.0.0.1:7777
landlined doctor
```

`doctor` prints the URL to enter in the app.

Linux bottles are built on Ubuntu 22.04, so they need glibc 2.35 or newer.
Older distributions can build from source with `cargo build --release -p landlined`.
