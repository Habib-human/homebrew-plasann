class Plasann < Formula
  desc "A plasmid annotation tool"
  homepage "https://github.com/ajlopatkin/PlasAnn"
  url "https://github.com/ajlopatkin/PlasAnn/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "86d5dae19b86719e2e976caed46b275cfaa1380449679cdc323871ee91560877"
  
  depends_on "blast"
  depends_on "prodigal"
  depends_on "python@3.9"
  
  def install
    # Just copy all scripts to a dedicated location
    (libexec/"Scripts").install Dir["Scripts/*"]
    
    # Install Python dependencies
    system "pip3", "install", "--user", "gdown", "biopython", "pandas", "matplotlib", "pycirclize"
    
    # Create a custom wrapper script
    (bin/"PlasAnn").write <<~EOS
      #!/bin/bash
      
      # Set PATH to include blast and prodigal
      export PATH="#{Formula["blast"].opt_bin}:#{Formula["prodigal"].opt_bin}:$PATH"
      
      # Create a temporary directory for importing
      TMPDIR=$(mktemp -d)
      
      # Create a simple import-friendly script in the temporary dir
      cat > $TMPDIR/run_plasann.py << 'EOF'
      import sys
      import os
      import argparse
      
      # Add the libexec directory to Python's path
      sys.path.append("#{libexec}")
      
      # Import from Scripts directory
      from Scripts import essential_annotation
      from Scripts import draw_plasmid
      
      # Import original main function
      sys.path.append("#{libexec}/Scripts")
      from annotate_plasmid import main
      
      if __name__ == "__main__":
          main()
      EOF
      
      # Run the script
      python3 $TMPDIR/run_plasann.py "$@"
      
      # Clean up
      rm -rf $TMPDIR
    EOS
    
    chmod 0755, bin/"PlasAnn"
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end