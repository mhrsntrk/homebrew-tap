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
  version "0.5.0"
  license "MIT"

  bottle do
    root_url "https://github.com/mhrsntrk/landline/releases/download/v0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e41e755e3110f9d138add3e27d3a93a797ca76963a4e0852a6d69caa6394bfe"
    sha256 cellar: :any_skip_relocation, sequoia:       "f524f43b947331fa10a5e7dc3d5b2ff05f0ac3971edebc4b19110d4e07a46819"
  end


  on_macos do
    on_arm do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.5.0/landlined-aarch64-apple-darwin"
      sha256 "8fbc1950658803766cc3b2724df735c3dbaecdf36c6aa1da5bef3b25caaeec19"
    end

    on_intel do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.5.0/landlined-x86_64-apple-darwin"
      sha256 "5028c9c7ec7eb10badd02c78bafa496579376388dc69f7e8b690952de9721750"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.5.0/landlined-aarch64-unknown-linux-gnu"
      sha256 "8c199e799f4bf2c0711652fa7971c14e849f45cc6e5c4e02d88b2a25cdaa1ee8"
    end

    on_intel do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.5.0/landlined-x86_64-unknown-linux-gnu"
      sha256 "078fe56df4d6276f387431eba8209d35b1673c0c1ba0de98a1aed41209f788a4"
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
