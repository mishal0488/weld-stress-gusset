function stress_plot(n,T,npe,stress)
hold on
  no_elements = size((T),1);
  for i = 1:no_elements
    X = zeros(1,npe+1);
    Y = zeros(1,npe+1);
    for j = 1:npe+1
      N = T(i,1+j); #get node
      X(1,j) = n(N,2);
      Y(1,j) = n(N,3);
      st(j) = n(N,1);
      if j == 1;
        f1 = st(j);
      endif
      if j == npe+1;
        X(1,j) = X(1,1);
        Y(1,j) = Y(1,1);
        st(j) = f1;
      endif
    endfor
    patch(X,Y,st);
  endfor
  colorbar
hold off

endfunction