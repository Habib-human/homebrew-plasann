class Plasann < Formula
  include Language::Python::Virtualenv

  desc "A plasmid annotation tool"
  homepage "https://github.com/ajlopatkin/PlasAnn"
  url "https://github.com/ajlopatkin/PlasAnn/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "86d5dae19b86719e2e976caed46b275cfaa1380449679cdc323871ee91560877"
  license "MIT"

  depends_on "python@3.9"
  depends_on "blast"
  depends_on "prodigal"

  def install
    virtualenv = virtualenv_create(libexec, "python@3.9")
    
    # Install dependencies directly from PyPI
    system libexec/"bin/pip", "install", "biopython"
    system libexec/"bin/pip", "install", "pandas"
    system libexec/"bin/pip", "install", "matplotlib"
    system libexec/"bin/pip", "install", "pycirclize"
    system libexec/"bin/pip", "install", "gdown"
    
    # Install the package itself
    virtualenv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end