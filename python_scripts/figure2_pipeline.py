genes = open("/Users/jacobluber/Desktop/athlete_genes",'r')
significant_anova = open("/Users/jacobluber/Desktop/manual_reactions/filtered_anova_output",'r')
genecat = []
sigs = []
for line in significant_anova:
    sigs.append(line.rstrip().split(",")[0])
significant_anova.close()
sigs_set = set(sigs)
d = {}
for line in genes:
    work_string = line.rstrip().split(' ')
    if work_string[0][1:] in sigs_set:
        sample = work_string[0][1:].split('_')[0]
        annotation = " ".join(work_string[1:])
        if d.has_key(annotation):
            temp_arr = d[annotation]
            new_arr = [sample]+temp_arr
            d[annotation] = new_arr
        else:
            new_arr = []
            new_arr.append(sample)
            d[annotation] = new_arr
genes.close()
output_f = open("fig2_heatmap_input_sig.csv",'w')
for annotation in d.keys():
    output_f.write(annotation+','+",".join(d[annotation])+'\n')
output_f.close()
