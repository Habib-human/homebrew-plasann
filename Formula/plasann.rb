class Plasann < Formula
  desc "A plasmid annotation tool"
  homepage "https://github.com/ajlopatkin/PlasAnn"
  url "https://github.com/ajlopatkin/PlasAnn/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "86d5dae19b86719e2e976caed46b275cfaa1380449679cdc323871ee91560877"
  
  depends_on "blast"
  depends_on "prodigal"
  depends_on "python@3.9"
  
  def install
    # Install the Scripts directory
    libexec.install "Scripts"
    
    # Install required dependencies
    system Formula["python@3.9"].opt_bin/"pip3", "install", "gdown", "biopython", "pandas", "matplotlib", "pycirclize"
    
    # Create a simple direct wrapper - no Python packaging involved
    (bin/"PlasAnn").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["blast"].opt_bin}:#{Formula["prodigal"].opt_bin}:$PATH"
      #{Formula["python@3.9"].opt_bin}/python3 "#{libexec}/Scripts/annotate_plasmid.py" "$@"
    EOS
    
    chmod 0755, bin/"PlasAnn"
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end