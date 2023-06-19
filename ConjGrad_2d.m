function [fnew,pnew,rnew,Lp] = ConjGrad_2d(f,q,pold,r,u_d1,u_d2,lvl,Lpold);
[nr,nc] = size(q);
[y, D1_MM, D2_MM, hprime, gprime] = atrous_down(q,lvl,u_d1,u_d2);
p = q(1,:);
for i = 2:nr
   p = [p q(i,:)];
end

Lq = atrous_up(lvl, hprime, gprime, y, D1_MM, D2_MM);
Lp = Lq(1,:);
for i = 2:nr
   Lp = [Lp Lq(i,:)];
end

lambda 	= (r*p')/(p*Lp');
fnew 	= f + lambda*p;
rnew	= r - lambda*Lp;
pnew	= Lp - ((Lp*Lp')/(p*Lp'))* p;
if ~(pold == 0),
    pnew = pnew  - ((Lp*Lpold')/(pold*Lpold'))* pold;
end