#Mishal Mohanlal 24/08/2020
#Ver 1
#Plots a truss and shows either material numbers or stresses
# input: N = nodes(number,x,y) C = connectivity(elements,node2,node2)
#        Stress = matrix for the stresses of members (optional input)

function Plottruss(N,C,stress)
hold on
for n = 1:size(N(:,1))
  plot3(N(n,2),N(n,3),'o') #placing nodes
endfor
for n = 1:size(C(:,1))
  for k = 1:size(N(:,1))
    if C(n,2) == N(k,1)
      x1 = N(k,2);
      y1 = N(k,3);
    endif
    if C(n,3) == N(k,1)
      x2 = N(k,2);
      y2 = N(k,3);
    endif
  endfor
  X = [x1 x2];
  Y = [y1 y2];
  mat = round(C(n,4));
  if nargin == 3
    mat = stress(n);
    text((x1+x2)*0.5,(y1+y2)*0.5,sprintf('%d',mat));
    if stress(n) > 0
        plot(X,Y,'r');
    endif
    if stress(n) < 0
        plot(X,Y,'b');
    endif
  endif
  if nargin == 2
      text((x1+x2)*0.5,(y1+y2)*0.5,sprintf('Mat no: %d',mat));
      plot(X,Y,'b');
  endif
endfor
hold off
endfunction
