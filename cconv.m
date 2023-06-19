function y = cconv(f,x)

m = length(x);
r = length(f);

x_extended = [x((m+1-r):m) x];


intermediate_y = filter(f,1,x_extended);

%Save only the part of the vector that has the circular convolution results: 
y = intermediate_y(r+1:m+r);