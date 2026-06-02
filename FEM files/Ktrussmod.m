#Mishal Mohanlal 06/08/2020
#Ver 1
#develops a modified stiffness matrix (Kmod) based on bounder conditions
#input: dof = column vector of supress degrees of freedom
#       K = Global stiffness matrix
function [Kmod] = Ktrussmod(dof,K)
  Kmod = K;
  dof = sort(dof(:,1),'descend');
 for i = 1:size(dof(:,1))
    Kmod(dof(i),:) = [];
    Kmod(:,dof(i)) = [];
  endfor
endfunction
