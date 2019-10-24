# This function calculates heights of trees given distance of each tree
# from its bas and angle to its top, using the trigometric formula
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees: The andgle of elevation of tree
# distance: The distance from base of tree (e.g., meters)

# OUTPUT
# The heights of the tree, same units as "distance"

TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    print(paste("Tree height is:", height))

    return (height)
}

TreeHeight(37,40)