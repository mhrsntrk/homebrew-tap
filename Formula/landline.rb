# frozen_string_literal: true

# Template for the mhrsntrk/homebrew-tap formula. This file does not live in
# the tap itself; the release workflow copies/updates a formula derived from
# this template by `sed`-replacing the placeholders below:
#   0.1.0   e.g. "0.3.0" (no leading "v")
#   3b487d68041ddb78765ecbe02ed7c80d2a2bffc6015a5423a50efe241343b813   sha256 of landlined-aarch64-apple-darwin
#   7475adc95c691d7f7bf0aa19b9b7bf5778caf792be56ea3f387d2f210f520a92   sha256 of landlined-x86_64-apple-darwin
#   53c76885a154f7393a8302a4269f3fb5887fb03200cd6e1176000d8522cad54e  sha256 of landlined-aarch64-unknown-linux-gnu
#   7f358dfa83a0a44c126e951f1a135877d846fb6bd306098a4039675c551e8721  sha256 of landlined-x86_64-unknown-linux-gnu
class Landline < Formula
  desc "Terminal on your iPhone, over your own tailnet"
  homepage "https://github.com/mhrsntrk/landline"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.1.0/landlined-aarch64-apple-darwin"
      sha256 "3b487d68041ddb78765ecbe02ed7c80d2a2bffc6015a5423a50efe241343b813"
    end

    on_intel do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.1.0/landlined-x86_64-apple-darwin"
      sha256 "7475adc95c691d7f7bf0aa19b9b7bf5778caf792be56ea3f387d2f210f520a92"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.1.0/landlined-aarch64-unknown-linux-gnu"
      sha256 "53c76885a154f7393a8302a4269f3fb5887fb03200cd6e1176000d8522cad54e"
    end

    on_intel do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.1.0/landlined-x86_64-unknown-linux-gnu"
      sha256 "7f358dfa83a0a44c126e951f1a135877d846fb6bd306098a4039675c551e8721"
    end
  end

  def install
    # Upstream ships one bare binary per platform (no archive), named after
    # its target triple. Install whichever one on_macos/on_arm/on_intel
    # resolved to as `landlined`.
    bin.install Dir["landlined-*"].first => "landlined"
  end

  # `caveats` is a method, not a DSL call. Written as `caveats <<~EOS`
  # Homebrew raises "undefined method 'caveats'" at install time, which
  # only shows up when someone actually installs the formula.
  def caveats
    <<~EOS
      Start the daemon and expose it on your tailnet:

        landlined install
        tailscale serve --bg --https=443 http://127.0.0.1:7777

      Then add this machine's ts.net hostname in the iOS app.

      Check it with `landlined doctor`, which reports the URL to enter.
    EOS
  end

  test do
    system "#{bin}/landlined", "--help"
  end
end
