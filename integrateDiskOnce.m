function [I] = integrateDiskOnce(f, Nu, Nv, mapping)
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% INTEGRATEDISKONCE Oblicza całkę na kole jednostkowym z użyciem
%                  złożonej metody trapezów w współrzędnych (u,v)
%
%   f       - uchwyt do do funkcji @(x,y), najlepiej wektoryzowanej
%   Nu, Nv  - Liczba podprzedziałow w kierunkach u, v na [-1,1]
%   mapping - 'linear' lub 'sqrt' w zależności od żadanej metody mapowania
%
%   I - przybliżenie całki

[U, V, h_u, h_v] = buildGridUV(Nu, Nv);

[X, Y, J] = mapUVtoXY(U, V, mapping);

try
    F = f(X,Y);
catch
    F = arrayfun(f, X, Y);
end

Nv_nodes = size(U, 1);
Nu_nodes = size(U, 2);

periodicTheta = false;

[wu, wv] = trapezoidWeights(Nu_nodes, Nv_nodes, periodicTheta);

W = wv* wu.';

integrand = F .* J;
I = h_u * h_v * sum(sum(W .* integrand));

end % Function