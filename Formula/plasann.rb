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
    
    # Create a custom version of annotate_plasmid.py with fixed imports
    (libexec/"fixed_annotate_plasmid.py").write <<~EOS
      #!/usr/bin/env python3
      
      import sys
      import os
      import subprocess as sp
      import time
      import shutil
      import argparse
      import gdown
      
      # Fix imports to use absolute paths instead of relative
      sys.path.insert(0, "#{libexec}")
      import Scripts.essential_annotation as essential_annotation
      import Scripts.draw_plasmid as draw_plasmid
      
      # Include the rest of the file from annotate_plasmid.py
      #{File.read(libexec/"Scripts/annotate_plasmid.py").lines[8..-1].join}
    EOS
    
    # Install required dependencies
    system Formula["python@3.9"].opt_bin/"pip3", "install", "gdown", "biopython", "pandas", "matplotlib", "pycirclize"
    
    # Create a wrapper script
    (bin/"PlasAnn").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["blast"].opt_bin}:#{Formula["prodigal"].opt_bin}:$PATH"
      #{Formula["python@3.9"].opt_bin}/python3 "#{libexec}/fixed_annotate_plasmid.py" "$@"
    EOS
    
    chmod 0755, bin/"PlasAnn"
    chmod 0755, libexec/"fixed_annotate_plasmid.py"
  end

  test do
    system "#{bin}/PlasAnn", "--help"
  end
end