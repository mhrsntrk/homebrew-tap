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
  version "0.2.0"
  license "MIT"

  bottle do
    root_url "https://github.com/mhrsntrk/landline/releases/download/v0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8bdeef0ce82a41586295ed4027d9e5c88509f2285e66bfbb3fde7e5f9be60d"
  end


  on_macos do
    on_arm do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.2.0/landlined-aarch64-apple-darwin"
      sha256 "c36f80414bcaf47aebd163e053eb7289facf28e0bbcff80479a645d54beaa1aa"
    end

    on_intel do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.2.0/landlined-x86_64-apple-darwin"
      sha256 "20bd85389fa0422626b83aa2ec9d0a1ef964ab1ab7f7c412cd3e8df75e91f1bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.2.0/landlined-aarch64-unknown-linux-gnu"
      sha256 "7b2469eec3645d27a005fac2c4dff41c3779c8ae35ef35ee43bb9bf2fbb76d38"
    end

    on_intel do
      url "https://github.com/mhrsntrk/landline/releases/download/v0.2.0/landlined-x86_64-unknown-linux-gnu"
      sha256 "da9d3d336a9d7541c1dd638a230073f1d261316ed511ae6f43ad44516a167fe9"
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
