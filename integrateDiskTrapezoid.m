function [res, err, time] = integrateDiskTrapezoid(f, Nu, Nv, mapping)
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% integrateDiskTrapezoid  Całkowanie po dysku jednostkowym metodą trapezów
%                         z prostym oszacowaniem błędu.
%
%   [res, err, time] = integrateDiskTrapezoid(f, Nu, Nv, mapping)
%
% Wejścia:
%   f       - uchwyt do funkcji @(x,y), najlepiej wektoryzowanej
%   Nu, Nv  - liczba podprzedziałów w kierunkach u, v na [-1,1]
%   mapping - 'linear' lub 'sqrt' (zgodnie z mapUVtoXY)
%
% Wyjścia:
%   res  - dokładniejsze przybliżenie całki (na siatce 2Nu x 2Nv)
%   err  - oszacowanie błędu = |I_refined - I_coarse|
%   time - czas wykonania (oba wywołania integratora)

if nargin < 4
    mapping = 'linear';
end
if nargin < 3
    Nv = Nu;
end

if Nu < 2 || Nv < 2
    error('Nu i Nv muszą być przynajmniej 2.');
end

tStart = tic;

% Przybliżenie na bazowej siatce
I_coarse = integrateDiskOnce(f, Nu,   Nv,   mapping);

% Przybliżenie na zagęszczonej siatce
I_fine   = integrateDiskOnce(f, 2*Nu, 2*Nv, mapping);

time = toc(tStart);

% Wynik i oszacowanie błędu
res = I_fine;
err = abs(I_fine - I_coarse);

end % Function
