function plotplate(n,T,npe,stress,st)

hold on
if nargin == 3
  no_elements = size((T),1);
  for i = 1:no_elements
  X = zeros(1,npe);
  Y = zeros(1,npe);
    for j = 1:npe
      N = T(i,1+j); #get node
      X(1,j) = n(N,2);
      Y(1,j) = n(N,3);
      text(X(1,j),Y(1,j),sprintf('%d',N),'Fontsize',16)
    endfor  
    patch(X,Y,'white');
  endfor
endif

if nargin == 5
  no_elements = size((T),1);
  for i = 1:no_elements
  X = zeros(1,npe);
  Y = zeros(1,npe);
    for j = 1:npe
      N = T(i,1+j); #get node
      X(1,j) = n(N,2);
      Y(1,j) = n(N,3);

    endfor  
    patch(X,Y,stress(st,i),'Facecolor','interp');
    
  endfor
  colorbar
endif
hold off

endfunction