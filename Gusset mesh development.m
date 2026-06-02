clc;
clear all;
P1 = [0 0];
P2 = [0 291];
P3 = [284 291];
P4 = [91 0];

mesh_size = 15;

Load = [126 9.5*1000 9.5*1000];
restraint_x = true; #restraint along axis
restraint_y = true;
weld_thickness = 6;
sides = 2;
g = [1 16 200000 0.25] #material number thickness E possions ratio

dof = 2 #degrees of freedom per node
npe = 3 #nodes per element


x = linspace(0,300,mesh_size); #nodes 
y = linspace(0,300,mesh_size);

#nodes around the perimeter of the polygon
x1 = linspace(0,P1(1,1),mesh_size)';
y1 = linspace(0,P2(1,2),mesh_size)';
x2 = linspace(P2(1,1),P3(1,1),mesh_size)';
y2 = linspace(P2(1,2),P3(1,2),mesh_size)';
x3 = linspace(P3(1,1),P4(1,1),mesh_size)';
y3 = linspace(P3(1,2),P4(1,2),mesh_size)';

[X,Y] = meshgrid(x,y);
X = [X x1 x2 x3];
Y = [Y y1 y2 y3];
xv = [P1(1,1) P2(1,1) P3(1,1) P4(1,1)]';
yv = [P1(1,2) P2(1,2) P3(1,2) P4(1,2)]';

[in,on] = inpolygon(X,Y,xv,yv);

counter = 0;
for i = 1:mesh_size
  for j = 1:mesh_size
    if in(i,j) == 1
      counter = counter+1;
      Lx(counter) = X(i,j);
      Ly(counter) = Y(i,j);
    endif
##    if on(i,j) == 1
##      counter = counter+1;
##      Lx(counter) = X(i,j);
##      Ly(counter) = Y(i,j);      
##    endif
  endfor
endfor
T = delaunay(Lx,Ly);
#triplot(T,Lx,Ly)

p = [Lx' Ly'];
nn = size(p);
node_no = transpose(linspace(1,nn(1,1),nn(1,1)));

nn = size(T);
element_no = transpose(linspace(1,nn(1,1),nn(1,1)));
mat_no = transpose(linspace(1,1,nn(1,1)));
T = [element_no T mat_no];

n = [node_no p];
q = dofM(dof,n);

figure(55)
plotplate(n,T,npe)

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

counter = 0;
cx = 0;
cy = 0;
#restrained degrees of freedom
n = round(n);
for i = 1:size(n(:,1))
  if (restraint_x == true) && (restraint_y == true)
    if (n(i,2) == 0) || (n(i,3) == 0)
      counter = counter+1;
      Rnodes(counter,1) = n(i,1);
      Rnodes(counter,2) = 1;
      Rnodes(counter,3) = 1;
    endif
  endif
  #storing the nodal restraints on the X and Y axis
  if n(i,2) == 0;
    cx = cx+1;
    R_x(cx,:) = n(i,:);
  endif
  if n(i,3) == 0;
    cy = cy+1;
    R_y(cy,:) = n(i,:);
  endif
endfor

#sorting restraints in terms of height and length
[~,idx] = sort(R_x(:,3));
sort_R_x = R_x(idx,:);

[~,idx] = sort(R_y(:,2));
sort_R_y = R_y(idx,:);

Rdof = transpose(Restraint(Rnodes,dof));
KRdof = Kmod(Rdof,K);




L = Load_vector(K,KRdof,Load,dof,Rdof)

disp = inv(KRdof)*L
Q = Gdisp(q,dof,Rdof,disp) #placing displacement into global matrix
[stress] = stress_tri(D,B,Q,T,n,2)
##figure(423)
##plotplate(n,T,npe,stress,3)
##figure(2)
##plotplate(n,T,npe)
Kd = Kdisp(K,Rdof,q);
Reaction = Kd*Q;
cx = 0;
cy = 0;
for i = 1:size(Reaction(:,1))
  if mod(i,2) == 0;
    cy = cy+1;
    Ry(cy) = Reaction(i);
  endif
  if mod(i,2) ~= 0
    cx = cx+1;
    Rx(cx) = Reaction(i);
  endif
endfor

c = size(Rx(1,:))
ch = linspace(1,c(1,2),c(1,2));
Rx = transpose([ch; Rx]);
Ry = transpose([ch; Ry]);
Rnodes = [transpose(ch) Rnodes];

TT = [sort_R_x;sort_R_y];
[~,idx] = sort(TT(:,1));
T_s = TT(idx,:);
T_s(1,:) = [];
T_s(:,2) = [];
T_s(:,2) = [];
for i = 1:size(sort_R_x(:,1))
  for j = 1:size(T_s(:,1))
    if sort_R_x(i,1) == T_s(j,1)
      sort_R_x(i,2) = Rx(j,2);
      sort_R_x(i,3) = Ry(j,2);
    endif
  endfor
endfor
for i = 1:size(sort_R_y(:,1))
  for j = 1:size(T_s(:,1))
    if sort_R_y(i,1) == T_s(j,1)
      sort_R_y(i,2) = Rx(j,2);
      sort_R_y(i,3) = Ry(j,2);
    endif
  endfor
endfor

#lengths of elements and stress in weld
c = size(sort_R_y(:,1));
for j = 1:size(sort_R_y(:,1))
  if (j == 1) 
    Len(j) = abs(n(sort_R_y(j,1),2)-n(sort_R_y(j+1,1),2))*0.5;#sqrt(n(sort_R_y(j,1),2)^2+n(sort_R_y(j+1,1),2)^2)*0.5
    L1(j) = n(sort_R_y(j,1),2);
  endif
  if j == c(1,1)
    Len(j) = abs(n(sort_R_y(j,1),2)-n(sort_R_y(j-1,1),2))*0.5;#sqrt(n(sort_R_y(j,1),2)^2+n(sort_R_y(j-1,1),2)^2)*0.5
        L1(j) = n(sort_R_y(j,1),2);
  endif
  if (j ~= 1) && (j ~= c(1,1))
    Len(j) = abs(n(sort_R_y(j,1),2)-n(sort_R_y(j+1,1),2));
    Len(j) = Len(j)*0.5+Len(j-1)*0.5;
    L1(j) = n(sort_R_y(j,1),2);
    Stress_Y_X(j) = sort_R_y(j,2)/(Len(j)*weld_thickness*sides);
    Stress_Y_Y(j) = sort_R_y(j,3)/(Len(j)*weld_thickness*sides);
    Resultant_Y(j) = sqrt(Stress_Y_X(j)^2+Stress_Y_Y(j)^2);
  endif
endfor

figure(10)
hold on
title("X and Y stresses along horizontal weld")
xlabel('Point');
ylabel('Stress in MPa');
plot(Stress_Y_X)
plot(Stress_Y_Y)
P1 = plot(Stress_Y_X)
P2 = plot(Stress_Y_Y)
legend([P1 P2],'Stress X','Stress Y');
hold off

c = size(sort_R_x(:,1));
for j = 1:size(sort_R_x(:,1))
  if (j == 1) 
    Len(j) = abs(n(sort_R_x(j,1),3)-n(sort_R_x(j+1,1),2))*0.5;#sqrt(n(sort_R_x(j,1),3)^2+n(sort_R_x(j+1,1),2)^2)*0.5
    L1(j) = Len(j);
  endif
  if j == c(1,1)
    Len(j) = abs(n(sort_R_x(j,1),3)-n(sort_R_x(j-1,1),2))*0.5;#sqrt(n(sort_R_x(j,1),3)^2+n(sort_R_x(j-1,1),2)^2)*0.5
        L1(j) = Len(j);
  endif
  if (j ~= 1) && (j ~= c(1,1))
    Len(j) = abs(n(sort_R_x(j,1),3)-n(sort_R_x(j+1,1),2));
    Len(j) = Len(j)*0.5+Len(j-1)*0.5;
    L1(j) = Len(j);
    Stress_X_X(j) = sort_R_x(j,2)/(Len(j)*weld_thickness*sides);
    Stress_X_Y(j) = sort_R_x(j,3)/(Len(j)*weld_thickness*sides);
    Resultant_X(j) = sqrt(Stress_X_X(j)^2+Stress_X_Y(j)^2);
  endif
endfor
figure(11)
hold on
title("X and Y stresses along vertical weld")
xlabel('Point');
ylabel('Stress in MPa');
plot(Stress_X_X)
plot(Stress_X_Y)
P1 = plot(Stress_X_X)
P2 = plot(Stress_X_Y)
legend([P1 P2],'Stress X','Stress Y');
hold off
figure(12)
hold on
title("Resultant stresses in welds")
xlabel('Point');
ylabel('Stress in MPa');
plot(Resultant_X)
plot(Resultant_Y)
P1 = plot(Resultant_X)
P2 = plot(Resultant_Y)
legend([P1 P2],'Vertical Weld','Horiozontal Weld');
hold off
figure(3)
title("X displacement in mm")
plotplate_disp(n,T,npe,Q,1)

figure(4)
title("Y displcement in mm")
plotplate_disp(n,T,npe,Q,2)



