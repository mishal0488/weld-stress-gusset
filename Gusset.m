clc;
clear all;
P1 = [0 0];
P2 = [0 291];
P3 = [284 291];
P4 = [91 0];
g = [1 0.5 30000000 0.25] #material number thickness E possions ratio

ms = 10;

dof = 2 #degrees of freedom per node
npe = 3 #nodes per element

delta_y = P2(1,2)/ms
delta_x = P3(1,1)/(ms*0.5)
delta_x1 = (P4(1,1)-P3(1,1))/(ms*0.5)

c1 = polyfit([P2(1,1) P3(1,1)],[P2(1,2) P3(1,2)],1) #gradient and y intercept between P2 and P3
c2 = polyfit([P3(1,1) P4(1,1)],[P3(1,2) P4(1,2)],1) #gradient and y intercept between P3 and P4

Lx = 0;
Ly = 0;
mm = ms;
check = false;
for i = 1:ms #mesh generation
  if mm == 0
    mm = 1;
  endif
  if i > 1
    if (x <= P3(1,1)) 
      x = x+delta_x;
      y = c1(1,1)*x+c1(1,2);
      mm = ms-i;
      L1y = linspace(0,y,mm);
      L1x = linspace(x,x,mm);
      Lx = [Lx L1x];
      Ly = [Ly L1y];
    endif
    if (x > P3(1,1)) && (check == true)
      x = x+delta_x1;
      y = c2(1,1)*x+c2(1,2);
      mm = ms-i;
      L1y = linspace(0,y,mm);
      L1x = linspace(x,x,mm);
      Lx = [Lx L1x];
      Ly = [Ly L1y];
    endif
  endif
  if i == 1
    x = 0;
    y = P2(1,2);
    mm = ms;
    L1y = linspace(0,y,mm);
    L1x = linspace(x,x,mm);
    Lx = [Lx L1x];
    Ly = [Ly L1y];
  endif
  if x == P3(1,1)
    check = true;
  endif
endfor
#L1x = P4(1,1);
#L1y = P4(1,2);
Lx = [Lx L1x];
Ly = [Ly L1y];
T = delaunay(Lx,Ly);

figure()
triplot(T,Lx,Ly)

#add node number and material property numbers
nn = size(T);
element_no = transpose((linspace(1,nn(1,1),nn(1,1))));
mat = transpose(linspace(1,1,nn(1,1)));
T = [element_no T mat];
n = transpose([Lx;Ly]);
nn = size(n);
node_no = transpose(linspace(1,nn(1,1),nn(1,1)));
n = [node_no n];
q = dofM(dof,n);
# create a blank global stiffness matrix
a = size(n);
m_size = dof*n(a(1,1),1);
K = zeros(m_size);

#loop over the amount of elements to create global K
for l = 1:(size(T(:,1)))
  [ke b d] = KeCST(T(l,:),g,n); #local stiffness matrix
  [A,Q] = Assembly(q,T(l,:),ke,npe,dof,n);
  K = K+A;
  B(:,:,l) = b;
  D(:,:,l) = d;
endfor

#restrained degrees of freedom
y = transpose(linspace(1,ms,ms));
y_const = transpose(linspace(1,1,ms));
Rnodes = [y y_const y_const];
Rdof_Y = transpose(Restraint(Rnodes,dof));





