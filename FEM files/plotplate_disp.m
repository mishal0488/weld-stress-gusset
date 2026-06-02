function plotplate_disp(n,T,npe,Q,uv)
hold on
  no_elements = size((T),1);
  for i = 1:no_elements
    X = zeros(1,npe+1);
    Y = zeros(1,npe+1);
    disp = zeros(1,npe+1);
    for j = 1:npe+1
      N = T(i,1+j); #get node
      if j == 1
        f1 = Q((n(N,1)-1)*2+uv);
      endif
      X(1,j) = n(N,2);
      Y(1,j) = n(N,3);
      disp(1,j) = Q((n(N,1)-1)*2+uv);
      if j == npe+1
        X(1,j) =  X(1,1);
        Y(1,j) =  Y(1,1);   
        disp(1,j) = f1;
      endif
      nn(j) = N;
    endfor  
    patch(X,Y,disp);
  endfor
  colorbar
hold off

endfunction