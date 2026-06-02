#Mishal Mohanlal 06/08/2020
#Ver 1

function [vec] = Lvector(N,C,Load,sdof)
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
  vec = zeros(dof(n,1)+1,1);
  dof;
  for n = 1:size(dof(:,1))
    for i = 1:size(Load(:,1))
      if dof(n,1) == Load(i,1)
        vec(dof(n,1)) = Load(i,2);
      endif
      if dof(n,2) == Load(i,1)
        vec(dof(n,2)) = Load(i,2);       
      endif
    endfor
  endfor
  sdof = sort(sdof(:,1),'descend')
  for i = 1:size(sdof(:,1))
    vec(sdof(i)) = [];
  endfor
endfunction
