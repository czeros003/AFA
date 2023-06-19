function p = atrous_up(levels,hprime,gprime,a,D1_MM, D2_MM)

L=levels;	
%L=level of detail
[nr,nc]=size(a);
y = a;
%-------------------------------
%Loop for reconstructing Lenna
%-------------------------------
for k = L:-1:1
   
   %Calculate filters
   gprime = dyaddown(gprime,3);
   hprime = dyaddown(hprime,3);
   
   %Shift and convolve the last approximation that was done before modulus maximus was calculated 
	for i=1:nr
     	rec_a{k}(i,1:nc) = cconv(hprime,y(i,1:nc));
      rec_a{k}(i,1:nc) = leftshift(rec_a{k}(i,1:nc),2^k);      
   end;
   for i=1:nc
      rec_a{k}(1:nr,i) = cconv(hprime,rec_a{k}(1:nr,i)')';
      rec_a{k}(1:nr,i) = leftshift(rec_a{k}(1:nr,i)',2^k)';
   end;


   for i=1:nc
      rec_d1{k}(1:nr,i)=leftshift(D1_MM(1:nr,i,k)',2^(k-1))';
      rec_d1{k}(1:nr,i)=cconv(gprime,rec_d1{k}(1:nr,i)')';
	end;
	for i=1:nr
      rec_d2{k}(i,1:nc)=leftshift(D2_MM(i,1:nc,k),2^(k-1));
      rec_d2{k}(i,1:nc)=cconv(gprime,rec_d2{k}(i,1:nc));
   end;

   y = rec_a{k} + rec_d1{k} + rec_d2{k};
end
p = y;