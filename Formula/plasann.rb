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
  
    resource "biopython" do
      url "https://files.pythonhosted.org/packages/7e/ce/02941904f65e0b27a0c3a3bf67fbfa0e4648c4e765b02b3d09e7cc7139c8/biopython-1.85.tar.gz"
      sha256 "85702d00ac816b664a00ad99db02159e76d02aea325d841a32fc913b9c4213d6"
    end
  
    resource "pandas" do
      url "https://files.pythonhosted.org/packages/af/bd/c7e72644493b74da239704b2e70c6f28fe859034928a129e456c0c724db8/pandas-1.5.2.tar.gz"
      sha256 "2896b87b6381c3ef75a89963c846ee398339c656abfb0e234eab2172a108b8d3"
    end
  
    resource "matplotlib" do
      url "https://files.pythonhosted.org/packages/89/59/d5471b09daea2e100a9133cbfad7af23deec4acf3b953406f3c3d2f19f31/matplotlib-3.7.0.tar.gz"
      sha256 "4f9fbf9467529c952dca079d3efe2a68adf627513e5ed73bcc61dee64dba92eb"
    end
  
    resource "pycirclize" do
      url "https://files.pythonhosted.org/packages/41/e2/b9f1ea8f7cce2b91f49fe8b08f7ca6b38d9ac037e95163789a67e7adbf3e/pycirclize-0.3.1.tar.gz"
      sha256 "23609bbb4fcd7ef0e9dd95e8e0c1dca2faa1e53bd5e4f9a3e7377ae33ba7a4da"
    end
  
    resource "gdown" do
      url "https://files.pythonhosted.org/packages/8e/c3/da56aebbbefa3923dc60c4caafb1ca2dec1e10d5ff92c92c375de90c9b5e/gdown-4.6.6.tar.gz"
      sha256 "2fb11d5fb0f241ef0a4c88c31b0418e424ff6fd4488e75ac501a21618ba2e19d"
    end
  
    def install
      virtualenv_install_with_resources
    end
  
    test do
      system "#{bin}/PlasAnn", "--help"
    end
  end