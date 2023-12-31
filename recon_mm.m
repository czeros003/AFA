function recon_mm(lvl,Threshold)
[X,map] = imread('Lena.bmp');
Lena = ind2gray(X,map);
y=Lena(50:177,50:177);
%y = Lena;
save_orig = y;
[nr,nc]=size(y);


[a, D1_MM, D2_MM, gprime, hprime] = mm_atrous(lvl,Threshold);

%u_a = (abs(a) > 0);
u_d1 = (abs(D1_MM) > 0);
u_d2 = (abs(D2_MM) > 0);

p = atrous_up(lvl, hprime, gprime, a, D1_MM, D2_MM);

f = zeros(1, nr*nc);
pold = zeros(1,nr*nc);
r = p(1,:);
for i = 2:nr
  	r = [r p(i,:)];
end
  
Lpold = zeros(1,nr*nc);
imax = 16;
i = 0;
while i<imax
   i = i+1;
   [fnew,pnew,rnew,Lp] = ConjGrad_2d(f,p,pold,r,u_d1,u_d2,lvl,Lpold);
   f = fnew;
   pold = p(1,:);
	for j = 2:nr
   	pold = [pold p(j,:)];
	end

	p = pnew(1:nc);
	for j = 1:nr-1
   	p = [p; pnew(1+(j*nc):(j+1)*nr);];
   end
   r = rnew;
   Lpold = Lp;
end

%Calculate signal-to-noise ratio
f_image = f(1:nc);
for j = 1:nr-1
   f_image = [f_image; f(1+(j*nc):(j+1)*nr);];
end

var_s = (std2(save_orig))^2;
var_n = (std2(double(save_orig) - f_image))^2;
snr = 10*log10(var_s/var_n);

figure
imshow(save_orig,[]);
title('Original Image');
figure
imshow(f_image,[]);
title(['Reconstructed Image from the Modulus Maxima - SNR = ',num2str(snr),'dB']);