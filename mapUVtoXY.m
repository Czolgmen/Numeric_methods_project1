function [X, Y, J] = mapUVtoXY(U, V, mapping)
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% MAPUVTOXY Mapuje (u,v) z kwadratu [-1,1]^2 na dysk jednostkowy.
%
%   U, V    - macierze współrzędnych u, v (tej samej wielkości),
%             zwykle z meshgrid(u, v).
%   mapping - 'linear', 'sqrt', 'm1', 'm3'
%
%   X, Y    - współrzędne na płaszczyźnie:
%                (X, Y) = Phi(U, V)
%   J       - macierz Jacobianu | det d(x,y)/d(u,v) |:
%       'linear': J(u,v) = (pi/2) * r(u)
%       'sqrt'  : J(u,v) = pi/4 (stała)
%       'm1'    : J(u,v) = sqrt(1 - u^2)
%       'm3'    : J(u,v) = wyrażenie z pochodnych (patrz kod)

if ~isequal(size(U), size(V))
    error('U i V muszą być tego samego rozmiaru.');
end

if isstring(mapping)
    mapping = char(mapping);
end

switch lower(mapping)
    case 'linear'
        % r(u) = (u + 1)/2, theta(v) = pi * v
        theta = pi * V;
        r     = 0.5 * (U + 1);

        X = r .* cos(theta);
        Y = r .* sin(theta);

        J = (pi / 2) * r;

    case 'sqrt'
        % r(u) = sqrt((u + 1)/2), theta(v) = pi * v
        theta = pi * V;
        r     = sqrt(0.5 * (U + 1));

        X = r .* cos(theta);
        Y = r .* sin(theta);

        J = (pi / 4) * ones(size(U));

    case 'm1'
        %   J(u,v) = sqrt(1 - u^2)
        % Dajemy max(0, ...) żeby uniknąć NaN przez zaokrąglenia.

        factor = sqrt(max(0, 1 - U.^2));

        X = U;
        Y = V .* factor;
        J = factor;

    case 'm3'
        %   J = dX/dU * dY/dV - dX/dV * dY/dU
        %     = A*B + (U^2 V^2) / (4 (1 - V^2/2)^(3/2) * B)
        %   gdzie:
        %     A = 1 / sqrt(1 - V^2/2)
        %     B = sqrt(1 - U^2/2)

        % zabezpieczenie przed ujemnym argumentem sqrta
        aV = sqrt(max(0, 1 - 0.5 * V.^2));
        bU = sqrt(max(0, 1 - 0.5 * U.^2));

        X = U .* aV;
        Y = V .* bU;

        J = aV .* bU - (U.^2 .* V.^2) ./ (4 .* aV .* bU);
        
    otherwise
        error( ...
        'Nieznany mapping "%s". Użyj "linear", "sqrt", "m1" lub "m3".', ...
         mapping);
end
end
