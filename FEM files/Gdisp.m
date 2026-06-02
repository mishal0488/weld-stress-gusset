#Mishal Mohanlal 25/01/2021
#takes displacement results and places in a global displacement matrix_type
# input: 
#        Q matrix with numbered degrees of freedom
#        dof,Rdof degrees of freedom per node and restrained degrees of freedom
#        Displacement, results attained through K^-1*F

function Q = Gdisp(Q,dof,Rdof,Displacement)

  n = size(Q(:,1),1); #number of nodes
  Q = reshape(Q,n*dof,1);
  Q = sort(Q(:,1));
  
  #develop global displacement matrix n*dofx1
  for j = 1:n*dof 
    for k = 1:size(Rdof,1)
      if Q(j) == Rdof(k)
        Q(j) = 0;
      endif
    endfor
  endfor
  check = 0
  for j = 1:n*dof
    if Q(j) ~= 0;
      check = check+1;
      Q(j) = Displacement(check);
    endif
  endfor
endfunction 