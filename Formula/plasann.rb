class Plasann < Formula
  include Language::Python::Virtualenv
  
  desc "A plasmid annotation tool"
  homepage "https://github.com/ajlopatkin/PlasAnn"
  url "https://files.pythonhosted.org/packages/source/p/plasann/plasann-1.0.7.tar.gz"
  sha256 "545dd1f357effbd9183b15d0e9df69aae8074c10d1d4ae0790fa991aec64c705"
  
  depends_on "blast"
  depends_on "prodigal"
  depends_on "python@3.9"

  # Define Python resources
  resource "gdown" do
    url "https://pypi.io/packages/source/g/gdown/gdown-4.7.1.tar.gz"
    sha256 "d6d231ceb8a1b375369bb4031c5b0a0380bd0147e9b9aac2d9c3aeda15db6e11"
  end
  
  resource "biopython" do
    url "https://pypi.io/packages/source/b/biopython/biopython-1.83.tar.gz"
    sha256 "fc5b28d8d3d7e52fb41914da380b93a1f2cfd3ebcd799abc37e73d94bbe25de2"
  end
  
  resource "pandas" do
    url "https://pypi.io/packages/source/p/pandas/pandas-2.1.4.tar.gz"
    sha256 "fcb68203651ecb9d671314c1a618d7ae4470fd961a150e5af3149951703aa742"
  end
  
  resource "matplotlib" do
    url "https://pypi.io/packages/source/m/matplotlib/matplotlib-3.8.2.tar.gz"
    sha256 "01a978b871b881ee76017152f1f1a0e0b33d4cadf58d7f9168bebd8d378f4bff"
  end
  
  resource "pycirclize" do
    url "https://pypi.io/packages/source/p/pycirclize/pycirclize-0.3.1.tar.gz"
    sha256 "23609bbb4fcd7ef0e9dd95e8e0c1dca2faa1e53bd5e4f9a3e7377ae33ba7a4da"
  end

  def install
    # Create and activate virtualenv
    virtualenv_install_with_resources
    
    # Create a wrapper script that modifies the Python path to find modules
    (bin/"PlasAnn").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["blast"].opt_bin}:#{Formula["prodigal"].opt_bin}:$PATH"
      export PYTHONPATH="#{libexec}/lib/python3.9/site-packages:$PYTHONPATH"
      "#{libexec}/bin/python3" -m Scripts.annotate_plasmid "$@"
    EOS
    
    chmod 0755, bin/"PlasAnn"
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end