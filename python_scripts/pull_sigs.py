genes = open("relative_abundances.csv",'r')
significant_anova = open("filtered_anova_output",'r')
metadata = open("metadata.txt",'r')
sigs = []
for line in significant_anova:
    sigs.append(line.rstrip().split(",")[0])
significant_anova.close()
sigs_set = set(sigs)
work_arr = []
sigs_set.add("GENE")
for line in genes:
    work_string = line.rstrip().split(',')
    if work_string[0] in sigs_set:
        work_arr.append(work_string)
arr_t = zip(*work_arr)
before = []
after = []
before.append(arr_t[0])
after.append(arr_t[0])
before_m = set()
after_m = set()
for line in metadata:
    parsed = line.rstrip().split('\t')
    if parsed[13] == "After":
        after_m.add(parsed[0])
    if parsed[13] == "Before":
        before_m.add(parsed[0])
for elem in arr_t:
    if "ru2" in elem[0]:
        search_id = elem[0].split('_')[0]
        if search_id in before_m:
            before.append(elem)
        if search_id in after_m:
            after.append(elem)
before_output = open("before_sigs.csv",'w')
after_output = open("after_sigs.csv",'w')
for elem in zip(*before):
    before_output.write(",".join(elem)+'\n')
for elem in zip(*after):
    after_output.write(",".join(elem)+'\n')
before_output.close()
after_output.close()
genes.close()
significant_anova.close()
