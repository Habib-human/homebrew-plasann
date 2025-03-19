class Plasann < Formula
  desc "A plasmid annotation tool"
  homepage "https://github.com/ajlopatkin/PlasAnn"
  url "https://github.com/ajlopatkin/PlasAnn/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "86d5dae19b86719e2e976caed46b275cfaa1380449679cdc323871ee91560877"
  license "MIT"

  depends_on "python@3.9"
  depends_on "blast"
  depends_on "prodigal"

  # These dependencies should be installed via pip
  resource "biopython" do
    url "https://files.pythonhosted.org/packages/7e/ce/02941904f65e0b27a0c3a3bf67fbfa0e4648c4e765b02b3d09e7cc7139c8/biopython-1.85.tar.gz"
    sha256 "85702d00ac816b664a00ad99db02159e76d02aea325d841a32fc913b9c4213d6"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/f5/00/dd7fa62efe9fa048d0c32fe1fe216c7e3a3b58a49ac0c070ce5968d3ef06/pandas-2.2.2.tar.gz"
    sha256 "ec4ef2cd42e5d2b3c77bf3b47136ee5f58550d25da50d4e23cc9c98a1f70d82a"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/3d/fe/fe52830a7ffc2c4fd09fa1752bb9572bdd9f37b089da948a9a9cea139a9f/matplotlib-3.9.1.tar.gz"
    sha256 "a13dde365593c42122608fb318ace0c54a2384689eac9c1d0c1f2515f984a206"
  end

  resource "pycirclize" do
    url "https://files.pythonhosted.org/packages/41/e2/b9f1ea8f7cce2b91f49fe8b08f7ca6b38d9ac037e95163789a67e7adbf3e/pycirclize-0.3.1.tar.gz"
    sha256 "23609bbb4fcd7ef0e9dd95e8e0c1dca2faa1e53bd5e4f9a3e7377ae33ba7a4da"
  end

  resource "gdown" do
    url "https://files.pythonhosted.org/packages/8e/c3/da56aebbbefa3923dc60c4caafb1ca2dec1e10d5ff92c92c375de90c9b5e/gdown-4.6.6.tar.gz"
    sha256 "2fb11d5fb0f241ef0a4c88c31b0418e424ff6fd4488e75ac501a21618ba2e19d"
  end

  # Add a patch method to create the script
  def install
    venv = virtualenv_create(libexec, "python3.9")

    # Install dependencies
    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", "-m", "pip", "install", *std_pip_args, "."
      end
    end

    # Install the package
    venv.pip_install_and_link buildpath

    # Create a wrapper script
    (bin/"PlasAnn").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["blast"].opt_bin}:#{Formula["prodigal"].opt_bin}:$PATH"
      "#{libexec}/bin/python" "#{libexec}/bin/PlasAnn" "$@"
    EOS
    
    # Make the script executable
    chmod 0755, bin/"PlasAnn"
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end