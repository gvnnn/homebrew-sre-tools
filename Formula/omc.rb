class Omc < Formula
  desc "OpenShift Must-Gather Client"
  homepage "https://github.com/gmeghnag/omc"
  url "https://github.com/gmeghnag/omc/archive/refs/tags/v3.19.1.tar.gz"
  sha256 "553b5d8063c1a5475fa32e34989269ba18b9d1c220e7e7ccf7caea3d147cd9c0"
  license "Apache-2.0"
  head "https://github.com/gmeghnag/omc.git", branch: "main"

  depends_on "go" => :build

  # The tarball vendors its dependencies, so the build needs no network.
  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/gmeghnag/omc/vars.OMCVersionTag=v#{version}
      -X github.com/gmeghnag/omc/vars.InstallMethod=homebrew
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"omc", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omc version")

    assert_match "is not a directory not a compressed file",
      shell_output("#{bin}/omc use #{testpath}/missing-must-gather 2>&1", 1)
  end
end
