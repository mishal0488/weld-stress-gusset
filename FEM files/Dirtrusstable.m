#Mishal Mohanlal 06/08/2020
#Ver 1
#input: Nodes(node number,x,y)
#       Connectivity matrix(element no,node1,node2,g) 
#       g is material matrix g(material no,elastic modulus, Area)
#outputs: Element numbers, element length, tansformation matrix l and m

function [E,le,l,m] = Dirtrusstable(N,C)
  #loop over amount of elements
  for n = 1:size(C(:,1))
    E(n) = C(n,1);
    for k = 1:size(N(:,1)) 
      if N(k,1) == C(n,2) #find first set of coordinates of elements
        x1 = [N(k,2) N(k,3)];
      endif
      if N(k,1) == C(n,3) #find second set of coordinates
        x2 = [N(k,2) N(k,3)];
      endif
    endfor
    le(n) = sqrt((x2(1)-x1(1))^2+(x2(2)-x1(2))^2);
    l(n) = (x2(1)-x1(1))/le(n);
    m(n) = (x2(2)-x1(2))/le(n);
  endfor
endfunction

