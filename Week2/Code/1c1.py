birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

# (1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

# (1.1) comprehension creating a list containing the latin names.
Latin_names = [i[0] for i in birds]
print(Latin_names)


# (1.2) comprehension creating a list containing the common names.
Common_names = [n for ]




# (1.3) comprehension creating a list containing the mean body masses.