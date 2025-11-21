function [U, V, h_u, h_v] = buildGridUV(Nu,Nv)
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% buildGridUV Buduje równomierną siatkę na [-1,1]x[-1,1]
%
%   Nu, Nv - liczba podprzedziałów w kierunkach u oraz v
%   U, V   - macierze współrzędnych
%   hu, hv - kroki siatki

% Jeśli brakuje drugiego argumentu zakładamy że siatka ma być kwadratowa
if nargin < 2
    Nv = Nu;
end

% Obliczamy krok dla całkowania
h_u = 2.0/Nu;
h_v = 2.0/Nv;

u = linspace(-1, 1, Nu + 1);
v = linspace(-1, 1, Nv + 1);

% Budujemy siatkę dla dalszych obliczeń
[U, V] = meshgrid(u,v);

end % Function