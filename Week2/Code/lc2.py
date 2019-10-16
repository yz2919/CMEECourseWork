# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
rainfall100 = ([i for i in rainfall if i[1]>100])
print(rainfall100)

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 
rainfall50 = ([i[0] for i in rainfall if i[1]<50])
print(rainfall50)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 
rainfall100 = []
rainfall50 = []
for i in rainfall:
    if i[1] > 100:
        rainfall100.append(tuple(i))
            
    if i[1] < 50:
        rainfall50.append(i[0])
print (rainfall100)
print (rainfall50)

