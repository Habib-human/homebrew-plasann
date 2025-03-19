class Plasann < Formula
  desc "A plasmid annotation tool"
  homepage "https://github.com/ajlopatkin/PlasAnn"
  
  # No need for URL or SHA since we're installing from PyPI
  
  depends_on "blast"
  depends_on "prodigal"
  depends_on "python@3.9"
  
  def install
    # Install the package from PyPI
    system "pip3", "install", "plasann"
    
    # Find where pip installed PlasAnn
    cmd_output = `pip3 show -f plasann | grep "Location:" | cut -d' ' -f2`.strip
    bin_path = `which PlasAnn`.strip
    
    # Create a wrapper script that ensures BLAST and Prodigal are in PATH
    (bin/"PlasAnn").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["blast"].opt_bin}:#{Formula["prodigal"].opt_bin}:$PATH"
      #{bin_path} "$@"
    EOS
    
    chmod 0755, bin/"PlasAnn"
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end