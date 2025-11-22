function [q, err, time] = P1Z18_ACZ_integrateDiskTrapezoid(f, n1, n2, mapping)
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% integrateDiskTrapezoid  Całkowanie po dysku jednostkowym metodą trapezów
%                         z prostym oszacowaniem błędu.
%
%   [q, err, time] = integrateDiskTrapezoid(f, n1, n2, mapping)
%
% Wejścia:
%   f       - uchwyt do funkcji @(x,y), najlepiej wektoryzowanej
%   n1, n2  - liczba podprzedziałów w kierunkach u, v na [-1,1]
%   mapping - 'linear', 'sqrt', 'm1', 'm3' (zgodnie z mapUVtoXY)
%             Jedyna zalecana metoda to 'linear', z pozostałych korzystasz
%             na własną odpowiedzialność
%
% Wyjścia:
%   q    - dokładniejsze przybliżenie całki (na siatce 2Nu x 2Nv)
%   err  - oszacowanie błędu = |I_refined - I_coarse|
%   time - czas wykonania (oba wywołania integratora)

if nargin < 4
    mapping = 'linear';
end
if nargin < 3
    n2 = n1;
end

if n1 < 2 || n2 < 2
    error('Nu i Nv muszą być przynajmniej 2.');
end

tStart = tic;

% Przybliżenie na bazowej siatce
I_coarse = integrateDiskOnce(f, n1,   n2,   mapping);

% Przybliżenie na zagęszczonej siatce
I_fine   = integrateDiskOnce(f, 2*n1, 2*n2, mapping);

time = toc(tStart);

% Wynik i oszacowanie błędu
q = I_fine;
err = abs(I_fine - I_coarse);

end % Function
