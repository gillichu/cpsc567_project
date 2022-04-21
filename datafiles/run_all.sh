#!/bin/bash

echo "[Reading in files...]"
#python select_genes.py 

echo "Wrote a 16S fasta file and a cytb fasta file!"

cat 16s_species.fasta > all_genes.fasta
cat cytb_species.fasta >> all_genes.fasta

echo "Wrote an all_genes.fasta file"

echo "[Running Alignments]"
mafft 16s_species.fasta > 16s_species.aln
mafft cytb_species.fasta > cytb_species.aln
mafft all_genes.fasta > all_genes.aln

mkdir -p aln_inputs
mkdir -p mafft_alns

mv *.fasta aln_inputs
mv *.aln mafft_alns
echo "[Running RAxML]"

./../methods/osx/raxml-ng_v1.1.0_macos_x86_64/raxml-ng --msa mafft_alns/16s_species.aln --model GTR+G
./../methods/osx/raxml-ng_v1.1.0_macos_x86_64/raxml-ng --msa mafft_alns/cytb_species.aln --model GTR+G

echo "[Consensus Tree]"
cat mafft_alns/16s_species.aln.raxml.bestTree > mafft_alns/all_species.gene.tre
cat mafft_alns/cytb_species.aln.raxml.bestTree >> mafft_alns/all_species.gene.tre

java -jar /Users/gillianchu/Desktop/cpsc/project/methods/osx/Astral/astral.5.7.8.jar -i /Users/gillianchu/Desktop/cpsc/project/datafiles/mafft_alns/all_species.gene.tre -o astral.consensus.tre

echo "[Done]"

