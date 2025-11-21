function [wu,wv] = trapezoidWeights(Nu,Nv,PeriodicTheta)
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% trapezoidWeights Wagi dla złożonej metody trapezów w kierunku v i u
%
%   Nu, Nv          - liczba węzłów w kierunkach u oraz v
%   periodivTheta   - jeśli true, to kierunek v traktujemy jako okresowy
%                     (np. kąt), więc wagi na krańcach są takie same
%   wu, wv          - wketory wag
%
%   Uwaga: długość wektorów wu, wv to odpowiednio Nu i Nv.
%   Krok siatki (hu, hv) mnożymy dopiero w funkcji całkującej

% Kierunek u - zwykły trapez (nieokresowy)
wu = ones(Nu, 1);
wu(1)   = 0.5;
wu(end) = 0.5;

% Kierunek v - zależy od periodicTheta
if PeriodicTheta
    % Okresowy (np. kąt: [0, 2*pi) bez powielania końca)
    % Dla funkcji okresowej trapez ma wszystkie wagi równe
    wv = ones(Nv, 1);
else
    wv = ones(Nv, 1);
    wv(1)   = 0.5;
    wv(end) = 0.5;
end

end % Function