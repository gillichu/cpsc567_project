#!/bin/bash

echo "[Reading in files...]"
python select_genes.py 

echo "Wrote a 16S fasta file and a cytb fasta file!"

cat 16s_species.fasta > all_genes.fasta
cat cytb_species.fasta >> all_genes.fasta

echo "Wrote an all_genes.fasta file"

echo "[Running Alignments]"
mafft 16s_species.fasta > 16s_species.aln
mafft cytb_species.fasta > cytb_species.aln
mafft all_genes.fasta > all_genes.aln

echo "[Running RAxML]"

./../methods/osx/raxml-ng_v1.1.0_macos_x86_64/raxml-ng --msa mafft\ alns/16s_species.aln --model GTR+G
./../methods/osx/raxml-ng_v1.1.0_macos_x86_64/raxml-ng --msa mafft\ alns/cytb_species.aln --model GTR+G
./../methods/osx/raxml-ng_v1.1.0_macos_x86_64/raxml-ng --msa mafft\ alns/all_genes.aln --model GTR+G

echo "[Done]"



