function [y, D1_MM, D2_MM, hprime, gprime] = atrous_down(y,lvl,u_d1,u_d2)

%Spline wavelet filters
hf=[.125 .375 .375 .125].*sqrt(2);
gf=[.5 -.5].*sqrt(2);
gprime = [0 0 -.5 .5 0 0].*sqrt(2);

L=lvl;	
%L=level of detail
[nr,nc]=size(y);
%-------------------------------
%Loop for decomposing Lenna
%-------------------------------

for k = 1:L
   %-------------------------------------
	%calculate approximations
	%-------------------------------------
   %shift either image or latest approximation vertically
   for i=1:nc
      a{k}(1:nr,i) = leftshift(y(1:nr,i)',2^(k-1))';
      %circular convolution of hd with colums from vertically shifted image
   	a{k}(1:nr,i) = cconv(hf,a{k}(1:nr,i)')';
   end
   
   %shift either image or latest approximation horizontally
   for i=1:nr
      a{k}(i,1:nc) = leftshift(a{k}(i,1:nc),2^(k-1));      
   	%circular convolution of hd with rows from horizontally shifted image
     	a{k}(i,1:nc) = cconv(hf,a{k}(i,1:nc));
   end;
	%-----------------------------------
	%calculate details d1 and d2
	%-----------------------------------
   %shift image or previous approximation vertically
   for i=1:nc
      d1{k}(1:nr,i)=cconv(gf,y(1:nr,i)')';
      d1{k}(1:nr,i)=leftshift(d1{k}(1:nr,i)',2^k)';
   end;
   %shift image or previous approximation horizontally
   for i=1:nr
      d2{k}(i,1:nc)=cconv(gf,y(i,1:nc));
      d2{k}(i,1:nc)=leftshift(d2{k}(i,1:nc),2^k);
   end;
   
   %calculate filters
   hf=[dyadup(hf,2) 0];  %a trous
   hprime = hf;
   gf=[dyadup(gf,2) 0];  %a trous
   gprime = [dyadup(gprime,2) 0];
   
   y = a{k};
   D1_MM(:,:,k) = d1{k};
   D2_MM(:,:,k) = d2{k};
end;
D1_MM = u_d1.*D1_MM;
D2_MM = u_d2.*D2_MM;