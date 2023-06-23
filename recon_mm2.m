
function recon_mm2(lvl,Threshold, image_name)
[X,map] = imread(image_name);
Lena = ind2gray(X,map);
y=Lena(50:177,50:177);
%y = Lena;
save_orig = y;
[nr,nc]=size(y);

[a, D1_MM, D2_MM, gprime, hprime, compressionRate] = mm_atrous_lena(lvl,Threshold, image_name);

% Progowanie dla każdego poziomu dekompozycji
for k = 1:lvl
    threshold_k = Threshold;
    if ~isscalar(Threshold)
        threshold_k = Threshold(k);
    end
    
    % Progowanie twarde
    u_d1 = abs(D1_MM(:,:,k)) > threshold_k;
    u_d2 = abs(D2_MM(:,:,k)) > threshold_k;
    D1_MM(:,:,k) = wthresh(D1_MM(:,:,k), 'h', threshold_k);
    D2_MM(:,:,k) = wthresh(D2_MM(:,:,k), 'h', threshold_k);

    % Progowanie miękkie
    D1_MM(:,:,k) = wthresh(D1_MM(:,:,k), 's', threshold_k);
    D2_MM(:,:,k) = wthresh(D2_MM(:,:,k), 's', threshold_k);

    % Rekonstrukcja obrazu
    p = atrous_up(lvl, hprime, gprime, a, D1_MM, D2_MM);
end

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

figure('Name', 'Wynik - Oryginał vs Rekonstrukcja');
% Display save_orig image
subplot(2,1,1);
imshow(save_orig,[]);
title('Original Image');

% Display f_image
subplot(2,1,2);
imshow(f_image,[]);
title(['Reconstructed Image from the Modulus Maxima - SNR = ',num2str(snr),'dB']);
xlabel(['Wyliczony stopień kompresji - ',num2str(compressionRate)]);

end