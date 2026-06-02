#Mishal Mohanlal 06/08/2020
#Ver 1
#develops a modified stiffness matrix (Kmod) based on boundery conditions
#input: dof = column vector of supress degrees of freedom
#       K = Global stiffness matrix
function A = Kmod(dof,K)
  dof = sort(dof(:,1),'descend');
 for i = 1:size(dof(:,1))
    K(dof(i),:) = [];
    K(:,dof(i)) = [];
  endfor
  A = K;
endfunction