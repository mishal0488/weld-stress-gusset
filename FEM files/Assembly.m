#Mishal Mohanlal 03/11/2020
# Locates the local stiffness matrix in the global stiffness matrix
# For loop is required to develop full global stiffness matrix
# input: dof = degrees of freedom per node
#        q = degrees of freedom per node, no numbers not included

function [A,Q] = Assembly(q,T,ke,npe,dof,n)

# create a blank global stiffness matrix
a = size(n);
m_size = dof*n(a(1,1),1);
Kdummy = zeros(m_size);

nodes = T(1,2:npe+1)';
for i = 1:npe
  A(i,:) = q(nodes(i),:);
endfor
B = reshape(A,npe*dof,1);
Q = sort(B);

Kdummy(Q,Q) = ke+Kdummy(Q,Q);
A = Kdummy;
endfunction