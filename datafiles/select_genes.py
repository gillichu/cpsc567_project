from Bio import SeqIO
import os, glob

folder_path = '/Users/gillianchu/Desktop/cpsc/project/datafiles/data2'
common_names = '/Users/gillianchu/Desktop/cpsc/project/datafiles/data2/speciesnames.txt'
name_dict = dict()

with open(common_names) as f:
	lines = f.readlines()
	for line in lines:
		print(line)
		before, after = line.split()
		name_dict[tuple(before.split('_'))] = after

print(name_dict)
	
print(folder_path)
fasta_paths = glob.glob(os.path.join(folder_path, '*.fasta'))
print(fasta_paths)

seqs_16s = list()
seqs_cytb = list()
all_records = set()

for fasta_path in fasta_paths:
	gene = ''
	#print(fasta_path)
	if "16s" in fasta_path.lower():
		gene = "16s"
	elif "cytb" in fasta_path.lower():
		gene = "cytb"
	else:
		gene = ''
	
	print(gene)
	for seq_record in SeqIO.parse(fasta_path, "fasta"):
		all_records.add(seq_record.id)
		
		#print(seq_record.id)
		if "16s" in seq_record.id.lower():
			gene = "16s"

		elif "cytb" in seq_record.id.lower():
			gene = "cytb"
	
		sr_id = ''
		if gene == "16s":
			sr_id = tuple(seq_record.id.rstrip().split('_')[:2])
		elif gene == "cytb":
			sr_id = tuple(seq_record.id.rstrip().split('_')[:2])
			#sr_id = seq_record.id.rstrip()[:-5]
		
		print(gene)
		print(seq_record.id, sr_id)
		print("becomes", name_dict[sr_id])
		seq_record.id = name_dict[sr_id]

		if gene == "16s":
			seqs_16s.append(seq_record)	
		elif gene == "cytb":
			seqs_cytb.append(seq_record)
		else:
			print("don't know :(", fasta_path, seq_record.id)	
		
		print(seq_record.id, gene)
	
	print(fasta_path, "contained", len(list(SeqIO.parse(fasta_path, "fasta"))), "files")

print(len(all_records))
print("16s", len(seqs_16s))
print("cytb", len(seqs_cytb))

SeqIO.write(seqs_16s, "16s_species.fasta", "fasta")
SeqIO.write(seqs_cytb, "cytb_species.fasta", "fasta")

