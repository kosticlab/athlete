import tax_tools as av
f = open("veil2.csv",'r')
a1 = av.fh_to_arr(f)
f.close()
a2 = map(lambda x: x.type, a1)
#print a2
newd = av.arr_to_dict(a1)
#print map(lambda x: x.abundance ,newd['SG16'].timepoints[newd['SG16'].timepoints.keys()[0]])


