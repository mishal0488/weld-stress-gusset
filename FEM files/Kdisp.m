function A = Kdisp(K,Rdof,q)
    c = 0;
    Rdof = sort(Rdof(:,1),'ascend')
    
for i = 1:size(Rdof(:,1))

  A(i,:) = K(Rdof(i),:);
endfor
endfunction
