birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

# (1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

# Latin names
Latin_names = [i[0] for i in birds]
print(Latin_names)

# Common names
Common_names = [i[1] for i in birds]
print(Common_names)

# Body masses.
Body_masses = [i[2] for i in birds]
print(Body_masses)

# (2) Now do the same using conventional loops. 

Latin_names = []
Common_names = []
Body_masses = []
for i in birds:
    Latin_names.append(i[0])
    Common_names.append(i[1])
    Body_masses.append(i[2])
print(Latin_names)
print(Common_names)
print(Body_masses)