from __future__ import division
import sys
import datetime

def reformat_strings(input_string): #some fields surrounded by "", some not
    if input_string[0] == "\"":
        return input_string[1:-1]
    else:
        return input_string

class Tax_entry: #class to easily handle entries from the ultrarower 16S otu-genus file
    def __init__(self,input_arr):
        self.abundance = int(input_arr[2])
        self.samplecode = input_arr[5]
        self.type = input_arr[6]
        self.time = datetime.datetime.strptime(input_arr[8],"%m/%d/%y")
        self.athlete = input_arr[18]
        self.gradient = input_arr[19]
        self.state = input_arr[20]
        self.intensity_num_str = input_arr[21] #NAs exist, deal with later
        self.intensity = input_arr[22]
        self.exercise_time = input_arr[23]
        self.genus = input_arr[102]
        self.ra = 0

def append_to_list(d,value): #deal with python bs
    newd = d
    newd.append(value)
    return newd

class Athlete: #class to easily handly athletes across time
    def __init__(self):
        self.timepoints = {}
        self.veill_trajectory = []
    def add_entry(self,new_entry): #adds a new Tax_entry object to a timepoint
        st = self.timepoints
        print new_entry.abundance
        if st.has_key(new_entry.time):
            st[new_entry.time] = append_to_list(st[new_entry.time],new_entry)
            #st[new_entry.time].append(new_entry)
        else:
            st[new_entry.time] = []
            st[new_entry.time] = append_to_list(st[new_entry.time],new_entry)
            #st[new_entry.time].append(new_entry)
        self.timepoints = st
        print map(lambda x: x.abundance, self.timepoints[new_entry.time])
    def do_calculations(self): #calculates genus level relative abundance per timepoints and generates a timecourse of Veillonella relative abundance per athlete
        timepoints = self.timepoints.keys()
        timepoints.sort()
        for timepoint in timepoints:
            print map(lambda x: x.abundance,self.timepoints[timepoint])
            tot_abundance = sum(map(lambda x: x.abundance,self.timepoints[timepoint]))
            for entry in self.timepoints[timepoint]:
                entry.ra = 0 if tot_abundance == 0 else entry.abundance/tot_abundance
                if entry.genus == "Veillonella":
                    print entry.ra
                    self.veill_trajcetory.append(entry.ra)

def fh_to_arr(fh): #filehandle to arr
    arr = []
    for lines in fh:
        if len(lines.rsplit(',')[8]) > 2: #some invalid entries in the input data with two quotes
            new_entry = Tax_entry(map(lambda x: reformat_strings(x), lines.rsplit(',')))
            arr.append(new_entry)
    return filter(lambda x: x.type == "Fecal", arr)

def arr_to_dict(arr): #arr to dict of athletes; hash on datetime object to faciliate later sorting
    athletes = set(map(lambda x: x.samplecode,arr))
    athlete_dict = {}
    for elem in athletes:
        athlete_dict[elem] = Athlete()
    for entry in arr:
        athlete_dict[entry.samplecode].add_entry(entry)
    return athlete_dict



