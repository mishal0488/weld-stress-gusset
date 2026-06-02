#Mishal Mohanlal 03/11/2020
#Develops the local stiffness matrix for an element
# input: nodes(x,y,z) T(element no,nodes,g)
# g = material matrix (material no,thickness,E,possions ratio)

function ke = Keplate(T,g,nodes)
  N1 = T(2)
  N2 = T(3)
  N3 = T(4)
  
endfunction