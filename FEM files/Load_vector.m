#Mishal Mohanlal 12/03/2021
#Ver 1
#input:
#       L = loads given as, node, q1,q2,...
#       K = global stiffness matrix, Kmod modified stiffness matrix
#       dof = degrees os freedom per node
#       Rdof = restrained degrees of freedom
function L_v = Load_vector(K,Kmod,L,dof,Rdof)

#create blank load vector
L_v = zeros(size(K(:,1)));
nn = size(L);
qs = nn(1,2)-1; #q1,q2,...
#L = sort(L(:,1),'ascend') #sorting loads 

[~,idx] = sort(L(:,1));
L = L(idx,:)

q_new = 0;
q = dofM(dof,L);
for i = 1:qs #changing q matrix into a column matrix
  q_new = [q_new;q(:,i)];
endfor

for i = 1:size(L(:,1))
  for j = 1:qs
    counter = (L(i,1)-1)*dof+j;
    L_v(counter) = L(i,j+1);
  endfor
endfor
L_v
Rdof = sort(Rdof(:,1),'descend');
for i = 1:size(Rdof(:,1))
  L_v(Rdof(i)) = [];
endfor
endfunction
