#Mishal Mohanlal 03/03/2021
#Produces a matrix for the retrained degrees of freedom
#input: Rnodes = node number, restraints (1/0)
#       dof = degrees of freedom per node
function R = Restraint(Rnodes,dof)
  counter = 0;
  for k = 1:size(Rnodes(:,1))
    for i = 1:(dof+1)
      if i > 1
        if Rnodes(k,i) == 1
          counter = counter+1;
          R(counter) = Rnodes(k,1)*dof-(dof+1)+i;
        endif
      endif     
    endfor
  endfor
endfunction
