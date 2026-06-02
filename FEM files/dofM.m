#Mishal Mohanlal 27/10/2020
#Develops a matrix for the numbering of the degrees
#of freedom at each node for a specified amount of dof at each node
#
#q = dof matrix
#dof = amount of degrees of freedom at each node
#nodes = node matrix (node number,x,y,z)

function q = dofM(dof,nodes)
  for k = 1:size(nodes(:,1))
    for i = 1:dof
      q(k,i) = (nodes(k,1)-1)*dof+i;
    end  
  endfor
end