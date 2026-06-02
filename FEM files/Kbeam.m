
#g = element number, E, density, area, I1, I2, J, G (shear modulus)
function [K] = Kbeam(N,C,g)
  
  #create a blank matrix which is the size of the global stiffness matrix
  K = size(N(:,1));
  K = K(1,1);
  K = K*6;
  K = zeros(K);

  
  #degrees of freedom for each node
  dof = dofM(6,N)
  
  e = size(C(:,1));
  e = e(1,1);
  i = size(N(:,1));
  i = i(1,1);
  #iterate for each element
  for i = 1:e 
    #node numbers
    N1 = C(i,2);
    N2 = C(i,3);
    #location of ndes in Node vector
    R1 = find(N(:,1) == N1);
    R2 = find(N(:,1) == N2);
    
    n1x = N(R1,2);
    n1y = N(R1,3);
    n1z = N(R1,4);
    
    n2x = N(R2,2);
    n2y = N(R2,3);
    n2z = N(R2,4);
    
    #length of the element
    l = sqrt((n1x-n2x)^2+(n1y-n2y)^2+(n1z-n2z)^2)
    
    
 #g = element number, density, area, I1, I2, J, G (shear modulus),E    
    #element property number
    epN = C(i,4);
    
    E = g(epN,8)
    A = g(epN,3);
    I1 = g(epN,4);
    I2 = g(epN,5);
    J = g(epN,6)
    G = g(epN,7)
    
    AS = E*A/l;
    TS = G*J/l
    az = 12*E*I1/l^3;
    bz = 6*E*I1/l^3;
    cz = 4*E*I1/l;
    dz = 2*E*I1/l;
    
    ay = 12*E*I2/l^3;
    by = 6*E*I2/l^3;
    cy = 4*E*I2/l;    
    dy = 2*E*I2/l;
    
    #element stiffness matrix
    k = [AS 0 0 0 0 0 -AS 0 0 0 0 0 ;
        0 az 0 0 0 bz 0 -az 0 0 0 bz;
        0 0 ay 0 -by 0 0 0 -ay 0 -by 0;
        0 0 0 TS 0 0 0 0 0 -TS 0 0;
        0 0 -by 0 cy 0 0 0 by 0 dy 0;
        0 bz 0 0 0 cz 0 -bz 0 0 0 dz;
        -AS 0 0 0 0 0 AS 0 0 0 0 0;
        0 -az 0 0 0 -bz 0 az 0 0 0 -bz;
        0 0 -ay 0 by 0 0 0 cy 0 by 0;
        0 0 0 -TS 0 0 0 0 0 TS 0 0;
        0 0 -by 0 dy 0 0 0 by 0 cy 0;
        0 bz 0 0 0 dz 0 -bz 0 0 0 cz];
        
     for j = 1:6
       q(j) = dof(N1,j);
       q(j+6) = dof(N2,j);    
     endfor
    for s = 1:12
      for t = 1:12
        K(q(s),q(t)) = K(q(s),q(t)) + k(s,t);
      endfor
    endfor 
     
                
    
  endfor
  
endfunction