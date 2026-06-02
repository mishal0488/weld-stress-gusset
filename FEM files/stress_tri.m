#Mishal Mohanlal 01/02/2021
#Calculation of the stesses in a 3 node element
# input: D, element strain displcement matrix, as a multidimensional matrix
#        B, material matrix as a multidimensional matrix
#        Q, global displacement matrix
#        T, topology matrix
#        n, nodes and dof, degrees of freedom per node
# output:stress given as a multidimensional matrix. [X Y XY]'

function [stress] = stress_tri(D,B,Q,T,n,dof)

q = dofM(dof,n);
no_elements = size((T),1);

for k = 1:no_elements
  d = zeros(1,6);
  for i = 1:3
    N = T(k,i+1);
    q1 = q(N,1);
    N1 = q1;
    q2 = q(N,2);
    q1 = Q(q1);
    q2 = Q(q2);
    if i == 1
      d(1,1) = q1;
      d(1,2) = q2;
    endif
    if i > 1
      d(1,(i*dof-1)) = q1;
      d(1,(i*dof-1)+1) = q2;
    endif
  endfor
  stress(:,:,k) = D(:,:,k)*B(:,:,k)*transpose(d);
endfor

endfunction 