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
    
    # Create a smart wrapper script that installs dependencies if needed
    (bin/"PlasAnn").write <<~EOS
      #!/bin/bash
      
      # Set path to include blast and prodigal
      export PATH="#{Formula["blast"].opt_bin}:#{Formula["prodigal"].opt_bin}:$PATH"
      
      # Check for required modules and install if missing
      python3 -c "import gdown" 2>/dev/null || pip3 install gdown
      python3 -c "import biopython" 2>/dev/null || pip3 install biopython
      python3 -c "import pandas" 2>/dev/null || pip3 install pandas
      python3 -c "import matplotlib" 2>/dev/null || pip3 install matplotlib
      python3 -c "import pycirclize" 2>/dev/null || pip3 install pycirclize
      
      # Run the script directly
      python3 "#{libexec}/Scripts/annotate_plasmid.py" "$@"
    EOS
    
    chmod 0755, bin/"PlasAnn"
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end