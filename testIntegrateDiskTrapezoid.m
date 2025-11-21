function testIntegrateDiskTrapezoid()
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% TESTINTEGRATEDISKTRAPEZOID
%   Testy poprawności działania funkcji integrateDiskTrapezoid.

    % zresetowanie licznika linii w myPrint
    myPrint(-1, '');

    myPrint(2, ['===== TEST POPRAWNOŚCI ' ...
                'integrateDiskTrapezoid =====\n\n']);

    tests = buildCorrectnessTests();

    for k = 1:numel(tests)
        t = tests(k);

        myPrint(1, 'Test %d:\n', k);
        myPrint(1, '  Funkcja:   %s\n', t.desc);
        myPrint(1, ['  Parametry: Nu = %d, Nv = %d, ' ...
                    'mapping = %s\n'], ...
            t.Nu, t.Nv, t.mapping);

        I_num = integrateDiskTrapezoid(t.f, t.Nu, t.Nv, t.mapping);

        myPrint(1, ['  Oczekiwana wartość I_exact: ' ...
                    '%.15g\n'], t.I_exact);
        myPrint(1, ['  Wynik obliczony I_num     : ' ...
                    '%.15g\n'], I_num);

        diff_val = abs(I_num - t.I_exact);
        myPrint(2, ['  Różnica |I_num - I_exact| : ' ...
                    '%.15g\n\n'], diff_val);
    end

    myPrint(1, ['===== Koniec testu poprawności ' ...
                'integrateDiskTrapezoid =====\n']);
end

%------------------------------------------------------------
% Definicja prostych testów z dokładnie znaną całką
%------------------------------------------------------------
function tests = buildCorrectnessTests()
    tests = struct([]);

    % 1) f = 1  -> całka = pi
    tests(end+1).desc    = 'f(x,y) = 1';
    tests(end  ).f       = @(x,y) ones(size(x));
    tests(end  ).I_exact = pi;
    tests(end  ).Nu      = 8;
    tests(end  ).Nv      = 8;
    tests(end  ).mapping = 'linear';

    % 2) f = 1, ten sam test dla mapping = sqrt
    tests(end+1).desc    = 'f(x,y) = 1';
    tests(end  ).f       = @(x,y) ones(size(x));
    tests(end  ).I_exact = pi;
    tests(end  ).Nu      = 8;
    tests(end  ).Nv      = 8;
    tests(end  ).mapping = 'sqrt';

    % 3) f = x   -> całka = 0 (symetria)
    tests(end+1).desc    = 'f(x,y) = x';
    tests(end  ).f       = @(x,y) x;
    tests(end  ).I_exact = 0;
    tests(end  ).Nu      = 8;
    tests(end  ).Nv      = 8;
    tests(end  ).mapping = 'linear';

    % 4) f = y   -> całka = 0 (symetria)
    tests(end+1).desc    = 'f(x,y) = y';
    tests(end  ).f       = @(x,y) y;
    tests(end  ).I_exact = 0;
    tests(end  ).Nu      = 8;
    tests(end  ).Nv      = 8;
    tests(end  ).mapping = 'sqrt';

    % 5) f = x^2 + y^2 -> całka = pi/2
    tests(end+1).desc    = 'f(x,y) = x^2 + y^2';
    tests(end  ).f       = @(x,y) x.^2 + y.^2;
    tests(end  ).I_exact = pi/2;
    tests(end  ).Nu      = 16;
    tests(end  ).Nv      = 16;
    tests(end  ).mapping = 'linear';

    % 6) f = x^2 + y^2 -> całka = pi/2 (mapping sqrt)
    tests(end+1).desc    = 'f(x,y) = x^2 + y^2';
    tests(end  ).f       = @(x,y) x.^2 + y.^2;
    tests(end  ).I_exact = pi/2;
    tests(end  ).Nu      = 16;
    tests(end  ).Nv      = 16;
    tests(end  ).mapping = 'sqrt';
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
