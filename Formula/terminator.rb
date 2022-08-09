class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "ee1907bc9bfe03244f6d8074b214ef1638a964b38e21ca2ad4cca993d0c1d31e"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c180712581d30b046b14a4ee5279f2cea55b3bff7a62b2737b21693e993996c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c177f5b4ceed9612e512051ae5ce29a4d04a9d26e942fbe485e4f5053f437e1"
    sha256 cellar: :any_skip_relocation, monterey:       "cf82ea3cadca21e1ae94e3b2fdb8e3d814f04d33623203797ec08fda18071ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8039dfc9e641c81615932afdb6bec92a512e123079974e4d87acbf6bd904a5fb"
    sha256 cellar: :any_skip_relocation, catalina:       "8c257067fdc58cceaa2f4f68fd569aa408db036faff673fe27f3950224745987"
    sha256 cellar: :any_skip_relocation, mojave:         "cbaae7d439b7f9fb6d2149c3fba76eefefb2120aac26504c60ebaab4d842846b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1dc76a8265f1bdfc5c593661afe56dbd247c3ee8ece4963c22894078b80adc9"
  end

  depends_on "pygobject3"
  depends_on "python@3.10"
  depends_on "six"
  depends_on "vte3"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    pid = Process.spawn bin/"terminator", "-d", [:out, :err] => "#{testpath}/output"
    sleep 30
    Process.kill "TERM", pid
    output = if OS.mac?
      "Window::create_layout: Making a child of type: Terminal"
    else
      "You need to run terminator in an X environment. Make sure $DISPLAY is properly set"
    end
    assert_match output, File.read("#{testpath}/output")
  ensure
    Process.kill "KILL", pid
  end
end
