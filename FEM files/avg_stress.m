function st = avg_stress(n,T,stress,dof,npe,typ)
  
  no_elements = size((T),1)
  for i = 1:size(n(:,1))
    total_stress = 0;
    counter = 0;
    for j = 1:no_elements
      for l = 1:npe
        if n(i,1) == T(j,l+1)
          counter = counter+1;
          s = stress(:,:,T(j,1));
          total_stress(counter) = s(typ,1);
        endif
      endfor
    endfor
    st(i) = mean(total_stress);
  endfor
endfunction
