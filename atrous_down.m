function [y, D1_MM, D2_MM, hprime, gprime] = atrous_down(y, lvl, u_d1, u_d2)
hf = [.125 .375 .375 .125] .* sqrt(2);
gf = [.5 -.5] .* sqrt(2);
gprime = [0 0 -.5 .5 0 0] .* sqrt(2);

L = lvl;
[nr, nc] = size(y);

for k = 1:L
    for i = 1:nc
        a{k}(1:nr, i) = leftshift(y(1:nr, i)', 2^(k - 1))';
        a{k}(1:nr, i) = cconv(hf, a{k}(1:nr, i)')';
    end

    for i = 1:nr
        a{k}(i, 1:nc) = leftshift(a{k}(i, 1:nc), 2^(k - 1));
        a{k}(i, 1:nc) = cconv(hf, a{k}(i, 1:nc));
    end

    if u_d1(k) > 0
        for i = 1:nc
            a{k + 1}(1:nr, i) = leftshift(y(1:nr, i)', 2^(k))';
            a{k + 1}(1:nr, i) = cconv(gf, a{k + 1}(1:nr, i)')';
        end

        for i = 1:nr
            a{k + 1}(i, 1:nc) = leftshift(a{k + 1}(i, 1:nc), 2^(k));
            a{k + 1}(i, 1:nc) = cconv(gf, a{k + 1}(i, 1:nc));
        end
    end

    if u_d2(k) > 0
        for i = 1:nc
            a{k + 2}(1:nr, i) = leftshift(y(1:nr, i)', 2^(k + 1))';
            a{k + 2}(1:nr, i) = cconv(gprime, a{k + 2}(1:nr, i)')';
        end

        for i = 1:nr
            a{k + 2}(i, 1:nc) = leftshift(a{k + 2}(i, 1:nc), 2^(k + 1));
            a{k + 2}(i, 1:nc) = cconv(gprime, a{k + 2}(i, 1:nc));
        end
    end
end

for i = 1:nc
    D1_MM(1:nr, i) = a{L + 1}(1:nr, i);
end

for i = 1:nr
    D1_MM(i, 1:nc) = a{L + 1}(i, 1:nc);
end

for i = 1:nc
    D2_MM(1:nr, i) = a{L + 2}(1:nr, i);
end

for i = 1:nr
    D2_MM(i, 1:nc) = a{L + 2}(i, 1:nc);
end

for i = 1:nc
    hprime(1:nr, i) = a{L}(1:nr, i);
end

for i = 1:nr
    hprime(i, 1:nc) = a{L}(i, 1:nc);
end
