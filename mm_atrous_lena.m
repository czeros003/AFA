function [y, D1_MM, D2_MM, gprime, hprime] = mm_atrous_tum(decomp_times,Threshold, image_name)

%Spline wavelet filters
hf=[.125 .375 .375 .125].*sqrt(2);
hprime = hf;
gf=[.5 -.5].*sqrt(2);
gprime = [0 0 -.5 .5 0 0].*sqrt(2);%[-0.03125 -0.21875 -0.6875 0.6875 0.21875 0.03125].*sqrt(2);

[X,map] = imread(image_name);
Lena = double(ind2gray(X,map));
y=Lena(50:177,50:177);

%A=imread('neck_tumor30_258x258.bmp');
%A=double(A);
%Xrgb=0.2990*A(:,:,1)+0.5870*A(:,:,2)+0.1140*A(:,:,3);
%NbColors=256;
%X=wcodemat(Xrgb,NbColors);
%map=gray(NbColors);
%Lena=X./256;
%y = Lena;
save_orig = y;
L=decomp_times;	
%L=level of detail
[nr,nc]=size(y);
hd=hf;
gd=gf;
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
   	a{k}(1:nr,i) = cconv(hd,a{k}(1:nr,i)')';
   end
   
   %shift either image or latest approximation horizontally
   for i=1:nr
      a{k}(i,1:nc) = leftshift(a{k}(i,1:nc),2^(k-1));      
   	%circular convolution of hd with rows from horizontally shifted image
     	a{k}(i,1:nc) = cconv(hd,a{k}(i,1:nc));
	end;
	%-----------------------------------
	%calculate details d1 and d2
	%-----------------------------------
   %shift image or previous approximation vertically
   for i=1:nc
      d1{k}(1:nr,i)=cconv(gd,y(1:nr,i)')';
      d1{k}(1:nr,i)=leftshift(d1{k}(1:nr,i)',2^k)';
      %d1 comes from convolving columns of shifted image
   end;
   %shift image or previous approximation horizontally
   for i=1:nr
      d2{k}(i,1:nc)=cconv(gd,y(i,1:nc));
      d2{k}(i,1:nc)=leftshift(d2{k}(i,1:nc),2^k);
      %d2 comes from convolving rows of shifted image
   end;
   
   %calculate filters
   hd=[dyadup(hd,2) 0];  %a trous
   hprime=hd;
   gd=[dyadup(gd,2) 0];  %a trous
   gprime=[dyadup(gprime,2) 0];
   y = a{k};
end;
%Threshold = 0;
%Calculate the modulus maxima for each level
for k = L:-1:1
   wtm{k} = sqrt(d1{k}.^2 + d2{k}.^2); %Wavelet Transform Modulus
   [mod_m,mod_n] = size(wtm{k});
   %Calculate angle of the wavelet transform vector
   for qt = 1:nr
      for r = 1:nc
         alpha{k}(qt,r) = atan2(d2{k}(qt,r),d1{k}(qt,r));
         if alpha{k}(qt,r) < 0
         	alpha{k}(qt,r)=2*pi+alpha{k}(qt,r);
         end
      end
   end

	%---------------------------
	%calculate modulus max image
	%---------------------------
	for r=1:mod_m
   	for c=1:mod_n
        mod_max{k}(r,c)=255;  %Initialize modulus maxima array
   	end
	end
	%find local maximum of modulus
	ang=pi/8;
	for r=2:mod_m-1
   	for c=2:mod_n-1
      	if (alpha{k}(r,c)>=(15*ang)|...
            	alpha{k}(r,c)<=(1*ang))&...
            	wtm{k}(r,c)>=Threshold &...
            	wtm{k}(r,c)>=wtm{k}(r-1,c) & wtm{k}(r,c) >= wtm{k}(r+1,c)
          	mod_max{k}(r,c)=0;
      	elseif (alpha{k}(r,c)>=(1*ang)&...
             	alpha{k}(r,c)<=(3*ang))&...
             	wtm{k}(r,c)>=Threshold &...
             	wtm{k}(r,c)>=wtm{k}(r-1,c-1) & wtm{k}(r,c) >= wtm{k}(r+1,c+1)
          	mod_max{k}(r,c)=0;
      	elseif (alpha{k}(r,c)>=(3*ang)&...
             	alpha{k}(r,c)<=(5*ang))&...
             	wtm{k}(r,c)>=Threshold &...
             	wtm{k}(r,c)>=wtm{k}(r,c-1) & wtm{k}(r,c) >= wtm{k}(r,c+1)
          	mod_max{k}(r,c)=0;
      	elseif (alpha{k}(r,c)>=(5*ang)&...
             	alpha{k}(r,c)<=(7*ang))&...
             	wtm{k}(r,c)>=Threshold &...
             	wtm{k}(r,c)>=wtm{k}(r-1,c+1) & wtm{k}(r,c) >= wtm{k}(r+1,c-1)
          	mod_max{k}(r,c)=0;
      	elseif (alpha{k}(r,c)>=(7*ang)&...
             	alpha{k}(r,c)<=(9*ang))&...
             	wtm{k}(r,c)>=Threshold &...
             	wtm{k}(r,c)>=wtm{k}(r-1,c) & wtm{k}(r,c) >= wtm{k}(r+1,c)
          	mod_max{k}(r,c)=0;
      	elseif (alpha{k}(r,c)>=(9*ang)&...
             	alpha{k}(r,c)<=(11*ang))&...
             	wtm{k}(r,c)>=Threshold &...
             	wtm{k}(r,c)>=wtm{k}(r-1,c-1) & wtm{k}(r,c) >= wtm{k}(r+1,c+1)
          	mod_max{k}(r,c)=0;
      	elseif (alpha{k}(r,c)>=(11*ang)&...
             	alpha{k}(r,c)<=(13*ang))&...
             	wtm{k}(r,c)>=Threshold &...
             	wtm{k}(r,c)>=wtm{k}(r,c-1) & wtm{k}(r,c) >= wtm{k}(r,c+1)
          	mod_max{k}(r,c)=0;
       	elseif (alpha{k}(r,c)>=(13*ang)&...
             	alpha{k}(r,c)<=(15*ang))&...
             	wtm{k}(r,c)>=Threshold &...
             	wtm{k}(r,c)>=wtm{k}(r-1,c+1) & wtm{k}(r,c) >= wtm{k}(r+1,c-1)
          	mod_max{k}(r,c)=0;
      	end
   	end
   end
end

%Build vertical and horizontal detail matrices that include only those ... 
%...coefficients that are located at the modulus maxima; otherwise, the...
%...coefficients are set to zero.
for k = 1:L
   d1_mm{k} = zeros(nr,nc);
   d2_mm{k} = zeros(nr,nc);
   for i = 1:nr
      for j = 1:nc
         if mod_max{k}(i,j) == 0
            d1_mm{k}(i,j) = d1{k}(i,j);
            d2_mm{k}(i,j) = d2{k}(i,j);
         end
      end
   end
   D1_MM(:,:,k) = d1_mm{k};
   D2_MM(:,:,k) = d2_mm{k};
end

for k = 1:decomp_times
   figure;
   subplot(3,1,1)
   imshow(a{k},[]);
   title(['Approximation for level ',num2str(k)]);
   subplot(3,1,2)
   imshow(d1{k},[]);
   title(['Horizontal details for level ',num2str(k)]);
	subplot(3,1,3)
	imshow(d2{k},[]);
   title(['Vertical details for level ',num2str(k)]);
end

figure;
for k = 1:decomp_times
   subplot(decomp_times,1,k)
   imshow(wtm{k},[]);
   if k == 1
      title('Wavelet Transform Modulus');
   end
end

figure;
for k = 1:decomp_times
   subplot(decomp_times,1,k)
   imshow(alpha{k},[]);
   if k == 1
     title('Angle of the Wavelet Transform Vector');
  end
end

figure;
zero_len = 0;
for k = 1:decomp_times
   subplot(decomp_times,1,k)
   imshow(mod_max{k},[]);
   zero_len = zero_len + length(find(mod_max{k}==0));
   if k == 1
     title('Modulus Maximum');
  end
end

[xsize,ysize] = size(mod_max{1});
data_len = xsize*ysize;
compressionRate = 100 - 100*(zero_len/data_len)

