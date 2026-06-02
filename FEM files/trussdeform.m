function trussdeform(N,C,displacement,supDOF)
  
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

endfunction

 