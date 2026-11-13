# frozen_string_literal: true

# Template for the mhrsntrk/homebrew-tap formula. This file does not live in
# the tap itself; the release workflow renders a formula from it by replacing
# the double-underscore placeholders below with the version and the checksums
# the release actually published: VERSION, SHA ARM, SHA X86, SHA LINUX ARM,
# SHA LINUX X86, and BOTTLE BLOCK.
#
# Those names are written without their underscores on purpose. The render
# step asserts that no placeholder survives, and a comment that spells one out
# literally would either be rewritten into nonsense or trip that assertion,
# depending on which placeholder it names. This comment cost a release once.
#
# BOTTLE BLOCK is emptied on the first pass and filled in later by the
# bottle-publish job, which runs `brew bottle --merge --write` against the
# formula already in the tap.
#
# The bottle block is not decoration. Without a bottle Homebrew treats this as
# a source build, even though `install` only copies an already-compiled binary,
# and it then refuses to proceed on any machine whose Command Line Tools are
# out of date. A bottle installs with no developer tools at all, and unlike a
# cask it carries no Gatekeeper quarantine, which matters while these binaries
# are still unsigned.
class Landline < Formula
  desc "Terminal on your iPhone, over your own tailnet"
  homepage "https://github.com/mhrsntrk/landline"
  version "0.4.0"
  license "MIT"

  bottle do
    root_url "https://github.com/mhrsntrk/landline/releases/download/v0.4.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "755d819341cad1d102713501dfd5a77e52e7bc5ce15abc383890067b90a15937"
    sha256 cellar: :any_skip_relocation, sequoia:       "90d0a85b6fbb8a6e9adecdf0efcebef95f6a40dac9be01f5ee21815209e16ae8"
  end


  on_macos do
    on_arm do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.4.0/landlined-aarch64-apple-darwin"
      sha256 "d744616526fec53b23cbdb814b8a390ca341ae67b74ebf84399b1801751e608b"
    end

    on_intel do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.4.0/landlined-x86_64-apple-darwin"
      sha256 "4f6e6159e34ebd807d0ac336d7d6bee945e56b7cc982c1ff602d713c81a15b24"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.4.0/landlined-aarch64-unknown-linux-gnu"
      sha256 "4d757db0544f3dc9389238bbe4014382cf64e85f4e29d60ed799d93b2c5aa89d"
    end

    on_intel do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.4.0/landlined-x86_64-unknown-linux-gnu"
      sha256 "d75b164dece64c0c2e8e8b653f325cd5eacb7b75809164afa0980fea9b5790be"
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
      Start the daemon, allow your tailnet login and turn on tailscale serve:

        landlined install

      Then add this machine's ts.net hostname in the iOS app.

      Check it with `landlined doctor`, which reports the URL to enter.
    EOS
  end

  test do
    system "#{bin}/landlined", "--help"
  end
end
