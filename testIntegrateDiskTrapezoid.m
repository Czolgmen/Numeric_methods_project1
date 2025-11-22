function testIntegrateDiskTrapezoid()
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% TESTINTEGRATEDISKTRAPEZOID
%   Testy poprawności działania funkcji integrateDiskTrapezoid.
%   Dla każdej funkcji testowej pokazujemy wyniki dla rosnących
%   rozmiarów siatki (Nu, Nv), gdzie w każdej iteracji Nu i Nv
%   są mnożone przez 2.

    % zresetowanie licznika linii w myPrint
    myPrint(-1, '');

    myPrint(2, ['===== TEST POPRAWNOŚCI ' ...
                'integrateDiskTrapezoid =====\n\n']);

    tests = buildCorrectnessTests();

    for k = 1:numel(tests)
        t = tests(k);

        myPrint(1, 'Test %d:\n', k);
        myPrint(1, '  Funkcja : %s\n', t.desc);
        myPrint(1, '  Mapping : %s\n', t.mapping);
        myPrint(1, ['  Wartość dokładna I_exact: ' ...
                    '%.15g\n'], t.I_exact);
        myPrint(2, ['  Siatka startowa: Nu = %d, Nv = %d, ' ...
                    'liczba poziomów: %d\n\n'], ...
                    t.N0, t.N0, t.nLevels);

        for lev = 0:(t.nLevels - 1)
            Nu = t.N0 * 2^lev;
            Nv = Nu;

            I_num = integrateDiskTrapezoid(t.f, Nu, Nv, t.mapping);
            diff_val = abs(I_num - t.I_exact);

            myPrint(1, '    Nu = %5d, Nv = %5d:\n', Nu, Nv);
            myPrint(1, ['      I_num                  = ' ...
                        '%.15g\n'], I_num);
            myPrint(2, ['      |I_num - I_exact|       = ' ...
                        '%.15g\n\n'], diff_val);
        end

        myPrint(1, '----------------------------------------\n\n');
    end

    myPrint(1, ['===== Koniec testu poprawności ' ...
                'integrateDiskTrapezoid =====\n']);
end

%------------------------------------------------------------
% Definicja prostych testów z dokładnie znaną całką
% Każdy test ma:
%   - N0      : rozmiar siatki startowej (Nu = Nv = N0)
%   - nLevels : ile razy mnożymy N przez 2
%------------------------------------------------------------
function tests = buildCorrectnessTests()
    tests = struct([]);

    % 1) f = 1  -> całka = pi, mapping = linear
    tests(end+1).desc    = 'f(x,y) = 1 (linear)';
    tests(end  ).f       = @(x,y) ones(size(x));
    tests(end  ).I_exact = pi;
    tests(end  ).mapping = 'linear';
    tests(end  ).N0      = 4;    % 4, 8, 16, 32, 64
    tests(end  ).nLevels = 5;

    % 2) f = 1  -> całka = pi, mapping = sqrt
    tests(end+1).desc    = 'f(x,y) = 1 (sqrt)';
    tests(end  ).f       = @(x,y) ones(size(x));
    tests(end  ).I_exact = pi;
    tests(end  ).mapping = 'sqrt';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 3) f = 1  -> całka = pi, mapping = m3
    tests(end+1).desc    = 'f(x,y) = 1 (m3)';
    tests(end  ).f       = @(x,y) ones(size(x));
    tests(end  ).I_exact = pi;
    tests(end  ).mapping = 'm3';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 4) f = x   -> całka = 0 (symetria), mapping = linear
    tests(end+1).desc    = 'f(x,y) = x (linear)';
    tests(end  ).f       = @(x,y) x;
    tests(end  ).I_exact = 0;
    tests(end  ).mapping = 'linear';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 5) f = |x| -> całka = 4/3, mapping = linear
    tests(end+1).desc    = 'f(x,y) = |x| (linear)';
    tests(end  ).f       = @(x,y) abs(x);
    tests(end  ).I_exact = 4/3;
    tests(end  ).mapping = 'linear';
    tests(end  ).N0      = 16;   % 16, 32, 64, 128, 256, 512
    tests(end  ).nLevels = 6;

    % 6) f = y   -> całka = 0 (symetria), mapping = sqrt
    tests(end+1).desc    = 'f(x,y) = y (sqrt)';
    tests(end  ).f       = @(x,y) y;
    tests(end  ).I_exact = 0;
    tests(end  ).mapping = 'sqrt';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 7) f = x^2 + y^2 -> całka = pi/2, mapping = linear
    tests(end+1).desc    = 'f(x,y) = x^2 + y^2 (linear)';
    tests(end  ).f       = @(x,y) x.^2 + y.^2;
    tests(end  ).I_exact = pi/2;
    tests(end  ).mapping = 'linear';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 8) f = x^2 + y^2 -> całka = pi/2, mapping = sqrt
    tests(end+1).desc    = 'f(x,y) = x^2 + y^2 (sqrt)';
    tests(end  ).f       = @(x,y) x.^2 + y.^2;
    tests(end  ).I_exact = pi/2;
    tests(end  ).mapping = 'sqrt';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 9) f = x^2 + y^2 -> całka = pi/2, mapping = m3
    tests(end+1).desc    = 'f(x,y) = x^2 + y^2 (m3)';
    tests(end  ).f       = @(x,y) x.^2 + y.^2;
    tests(end  ).I_exact = pi/2;
    tests(end  ).mapping = 'm3';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 10) f = x^2 -> całka = pi/4, mapping = linear
    tests(end+1).desc    = 'f(x,y) = x^2 (linear)';
    tests(end  ).f       = @(x,y) x.^2;
    tests(end  ).I_exact = pi/4;
    tests(end  ).mapping = 'linear';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 11) f = x^2 -> całka = pi/4, mapping = sqrt
    tests(end+1).desc    = 'f(x,y) = x^2 (sqrt)';
    tests(end  ).f       = @(x,y) x.^2;
    tests(end  ).I_exact = pi/4;
    tests(end  ).mapping = 'sqrt';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

    % 12) f = x^2 -> całka = pi/4, mapping = m3
    tests(end+1).desc    = 'f(x,y) = x^2 (m3)';
    tests(end  ).f       = @(x,y) x.^2;
    tests(end  ).I_exact = pi/4;
    tests(end  ).mapping = 'm3';
    tests(end  ).N0      = 4;
    tests(end  ).nLevels = 5;

end


%------------------------------------------------------------
% Pomocnicza funkcja wypisująca z liczeniem linii
% nLines < 0  -> reset licznika
%------------------------------------------------------------
function myPrint(nLines, varargin)
    persistent lineCount maxLines

    if isempty(maxLines)
        maxLines = 21;
    end

    if nLines < 0
        lineCount = 0;
        return;
    end

    if isempty(lineCount)
        lineCount = 0;
    end

    fprintf(varargin{:});
    lineCount = lineCount + nLines;

    if lineCount >= maxLines
        input('--- Naciśnij Enter, aby kontynuować ---','s');
        lineCount = 0;
    end
end
