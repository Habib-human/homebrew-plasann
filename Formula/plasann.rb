class Plasann < Formula
  desc "A plasmid annotation tool"
  homepage "https://github.com/ajlopatkin/PlasAnn"
  url "https://files.pythonhosted.org/packages/source/p/plasann/plasann-1.0.7.tar.gz"
  sha256 "545dd1f357effbd9183b15d0e9df69aae8074c10d1d4ae0790fa991aec64c705"
  
  depends_on "blast"
  depends_on "prodigal"
  depends_on "python@3.9"

  def install
    virtualenv_create(libexec, "python3.9")
    system libexec/"bin/pip", "install", "plasann"
    
    # Create a wrapper script
    (bin/"PlasAnn").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["blast"].opt_bin}:#{Formula["prodigal"].opt_bin}:$PATH"
      "#{libexec}/bin/PlasAnn" "$@"
    EOS
    
    chmod 0755, bin/"PlasAnn"
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end