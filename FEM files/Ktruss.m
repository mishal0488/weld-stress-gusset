#Mishal Mohanlal 06/08/2020
#Ver 1
#develops the global stiffness matric for truss elements
# input: N = nodes(number,x,y) C = connectivity(elements,node2,node2)
#        D = direction cosine table(element,le,l,m) l and m are transformation matices
#        g = (element number, elastic modulus, area)
# output: K = global stiffness matrix

function [K] = Ktruss(N,C,le,l,m,g)
  K = size(N); #create blank matrix
  K = K(1)*2;
  K = zeros(K);
  for n = 1:size(N(:,1)) #dof
    if n == 1
      dof(n,1) = 1;
      dof(n,2) = 2;
    endif
    if n > 1
      dof(n,1) = (n-1)*2+1;
      dof(n,2) = (n-1)*2+2;
    endif
  endfor
  for n = 1:size(C(:,1)) #loop over the amount of elements   
    k = g(C(n,4),2)*g(C(n,4),3)/le(n)*[l(n)^2 l(n)*m(n) -l(n)^2 -l(n)*m(n); #element stiffness matrix
                         l(n)*m(n) m(n)^2 -l(n)*m(n) -m(n)^2;
                         -l(n)^2 -l(n)*m(n) l(n)^2 l(n)*m(n);
                         -l(n)*m(n) -m(n)^2 l(n)*m(n) m(n)^2];
    
    node1 = C(n,2); #getting the two nodes of the element
    q(1) = dof(node1,1);
    q(2) = dof(node1,2);
    node2 = C(n,3);
    q(3) = dof(node2,1);
    q(4) = dof(node2,2);

    for s = 1:4
      for t = 1:4
        K(q(s),q(t)) = K(q(s),q(t)) + k(s,t);
      endfor
    endfor            
  endfor
end



