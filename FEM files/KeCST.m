#Mishal Mohanlal 03/11/2020
#Develops the local stiffness matrix for an element
# input: nodes(x,y,z) T(element no,nodes,g)
# g = material matrix (material no,thickness,E,possions ratio)

function [ke B D]  = KeCST(T,g,nodes)

  #find row (number placeholder) for each node in the node matrix
  N1 = find(nodes(:,1) == T(2));
  N2 = find(nodes(:,1) == T(3));
  N3 = find(nodes(:,1) == T(4));
  mat = find(T(1,5) == g(:,1));
  
  
  #placing the node coordinates in variables
  # N = node no, x ,y
  N1 = nodes(N1,:);
  N2 = nodes(N2,:);
  N3 = nodes(N3,:);
  N = [N1;N2;N3];
  mat = g(mat,:);
  
  J = det([N1(1,2)-N3(1,2) N1(1,3)-N3(1,3);N2(1,2)-N3(1,2) N2(1,3)-N3(1,3)]); #Jacobian
  
  B = 1/J*[N2(1,3)-N3(1,3) 0 N3(1,3)-N1(1,3) 0 N1(1,3)-N2(1,3) 0; #stress strain matrix
       0 N3(1,2)-N2(1,2) 0 N1(1,2)-N3(1,2) 0 N2(1,2)-N1(1,2);
       N3(1,2)-N2(1,2) N2(1,3)-N3(1,3) N1(1,2)-N3(1,2) N3(1,3)-N1(1,3) N2(1,2)-N1(1,2) N1(1,3)-N2(1,3)];
  
  #sorting B Matrix, local and global numbering alligns 
  [p idx] = sort(N(:,1));
  q = dofM(2,idx); 
  NN = [1;2;3];
  Q = dofM(2,NN);
  q = reshape(q,6,1);
  Q = reshape(Q,6,1);
  B_sorted = zeros(3,6);
  for i = 1:6
    Bsorted(1:3,Q(i)) = B(1:3,q(i));
  endfor
  B = Bsorted;
  
  A = 0.5*abs(J);
  v = mat(1,4); #poissons ratio
  E = mat(1,3); #elastic modulus
  D = E/(1-v^2)*[1 v 0;v 1 0;0 0 (1-v)/2]; #Material matrix 
  D*B;
  ke = mat(1,2)*A*transpose(B)*D*B;
  kg = zeros(6,6);

endfunction