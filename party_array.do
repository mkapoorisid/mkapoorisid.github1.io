clear all

import delimited "/Users/muditkapoor/Google Drive/ECI/ecidata/centroidsdata_election_2014.csv", encoding(ISO-8859-1)

keep state pc_name w_party w_votes

gen w_votes_s = w_votes
destring w_votes, replace force
drop if w_votes == .
move w_party pc_name
move state pc_name

sort w_party state w_votes

gen color = "#04C4FC" if w_party == "INC"
replace color = "green" if w_party == "AITC"
replace color = "#ff3399" if w_party == "TRS"
replace color = "yellow" if w_party == "TDP"
replace color = "#E69F19" if w_party == "BJP"
replace color = "red" if w_party == "ADMK"
replace color = "#EC5B13" if w_party == "SHS"
replace color = "#EC2434" if w_party == "CPM"
replace color = "#041444" if w_party == "YSRCP"
replace color = "#246C4C" if w_party == "BJD"
replace color = "blue" if w_party == "NCP"
replace color = "green" if w_party == "SP"
replace color = "#FFF0F5" if color == ""


gen id = _n

egen id_max = max(id)

by w_party state (id), sort: gen h = _n

by w_party state (id), sort: egen h_max = max(h)

by w_party (id), sort: gen h1 = _n

by w_party (id), sort: egen h1_max = max(h1)

gen a = "{"+`"""'+"name"+`"""'+": "+`"""'+"Votes"+`"""'+", "+ `"""'+"children"+`"""'+": [" if id == 1

gen b = "{"+`"""'+"name"+`"""'+": " +`"""'+w_party+`"""'+", "+`"""'+"color"+`"""'+": " +`"""'+color+`"""'+", "+`"""'+ "children"+`"""'+": [" if h1 == 1

gen c = "{"+`"""'+"name"+`"""'+": " +`"""'+ state +`"""'+", "+`"""'+"color"+`"""'+": " +`"""'+color+`"""'+", "+`"""'+ "children"+`"""'+": [" if h == 1

gen d = "{"+`"""'+"name"+`"""'+": "+`"""' + pc_name+`"""'+", "+`"""'+"color"+`"""'+": " +`"""'+color+`"""'+", "+`"""'+ "w_votes"+`"""'+": " + w_votes_s+"},"
replace d = subinstr(d, "},","}]},",.) if h == h_max
replace d = subinstr(d,"}]},","}]}]},",.) if h1 == h1_max
sort id
replace d = subinstr(d,"}]}]},","}]}]}]}",.) if id == id_max

gen e = a+b+c+d

