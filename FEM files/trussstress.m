#Mishal Mohanlal 24/08/2020
#Ver 1
# Returns the axial stress of all elements
# l,m,le,g,N,C,dof as previously defined by the other functions
# displacements = vector of displacements of unsupressed dof

function [stress] = trussstress(l,m,le,g,N,C,displacements,dof)
  
  for n = 1:size(N(:,1)) #dof
    if n == 1
      DOF(n,1) = 1;
      DOF(n,2) = 2;
    endif
    if n > 1
      DOF(n,1) = (n-1)*2+1;
      DOF(n,2) = (n-1)*2+2;
    endif
  endfor

  dof = sort(dof(:,1),'descend');
  D = size(N); #create blank matrix
  D = D(1)*2;
  D = 1:D;
  D = D';
  for n = 1:size(dof(:,1)) #displacement vector where degrees of freedom are left in
    for k = 1:size(D(:,1))
      if D(k,1) == dof(n,1)
        D(k,1) = 0;
      endif
    endfor
  endfor
  
  counter = 0; #placing displacement at correct locations
  for n = 1:size(D(:,1))
    for k = 1:size(displacements(:,1))
      if D(n,1) == n
        counter = counter+1;
        D(n,1) = displacements(counter,1);
      endif
    endfor
  endfor
  
  for n = 1:size(C(:,1)) #loop over the amount of elements   
    node1 = C(n,2); #getting the two nodes of the element
    q(1) = DOF(node1,1);
    q(2) = DOF(node1,2);
    node2 = C(n,3);
    q(3) = DOF(node2,1);
    q(4) = DOF(node2,2);
    for j = 1:4
      disp(j) = D(q(j));
    endfor
    stress(n) = g(C(n,4),2)/le(n)*[-l(n) -m(n) l(n) m(n)]*disp';
  endfor

endfunction
