#Mishal Mohanlal 11/08/2020
#Ver 1
# same algorithm as Ktruss, only element matrix is changed


function [M] = Lumpedtruss(N,C,le,l,m,g)
  M = size(N); #create blank matrix
  M = M(1)*2;
  M = zeros(M);
  for n = 1:size(N(:,1)) #dof
    if n == 1
      dof(n,1) = 1;
      dof(n,2) = 2;
    endif
    if n > 1
      dof(n,1) = (n-1)*2+1;
      dof(n,2) = (n-1)*2+2;
    endif
  endfor
  for n = 1:size(C(:,1)) #loop over the amount of elements 
    Me = g(C(n,4),4)*g(C(n,4),3)*le(n)/6*[2 0 1 0;
                                          0 2 0 1;
                                          1 0 2 0;
                                          0 1 0 2];
                                          
    node1 = C(n,2); #getting the two nodes of the element
    q(1) = dof(node1,1);
    q(2) = dof(node1,2);
    node2 = C(n,3);
    q(3) = dof(node2,1);
    q(4) = dof(node2,2);
    for s = 1:4
      for t = 1:4
        M(q(s),q(t)) = M(q(s),q(t)) + Me(s,t);
      endfor
    endfor  
  endfor
endfunction
