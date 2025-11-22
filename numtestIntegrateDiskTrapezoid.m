function numtestIntegrateDiskTrapezoid()
% Projekt 1, zadanie 18
% Artur Czołgosz, 339051
%
% NUMTESTINTEGRATEDISKTRAPEZOID
%   Testy numeryczne dla integrateDiskTrapezoid:
%   - kilka funkcji z dokładnie znaną całką po dysku jednostkowym
%   - porównanie mapowań 'linear' i 'sqrt'
%   - obserwacja zbieżności przy zagęszczaniu siatki
%
%   Uruchom:
%       >> numtestIntegrateDiskTrapezoid
    MAKE_PLOTS = false;  % <- gdy true, rysuje wykresy zbieżności

    N_list   = [4 8 16 32 64];
    mappings = {'linear','sqrt', 'm1', 'm3'};
    tests    = buildNumtestTests();

    myPrint('===== NUMERYCZNE TESTY integrateDiskTrapezoid =====\n\n');

    numtestTables(tests, mappings, N_list);
    numtestConvergence(tests, mappings, MAKE_PLOTS);

    myPrint('\nKoniec numerycznych testów.\n');
end

%---------------------------------------------
% Definicja funkcji testowych (f, I_exact)
%---------------------------------------------
function tests = buildNumtestTests()
    tests = struct([]);

    % 1) f = 1, integral = pi
    tests(end+1).name    = 'f(x,y) = 1';
    tests(end  ).f       = @(x,y) ones(size(x));
    tests(end  ).I_exact = pi;

    % 2) f = x, integral = 0
    tests(end+1).name    = 'f(x,y) = x';
    tests(end  ).f       = @(x,y) x;
    tests(end  ).I_exact = 0;

    tests(end+1).name    = 'f(x,y) = |x|';
    tests(end  ).f       = @(x,y) abs(x);
    tests(end  ).I_exact = 4/3;

    % 3) f = y, integral = 0
    tests(end+1).name    = 'f(x,y) = y';
    tests(end  ).f       = @(x,y) y;
    tests(end  ).I_exact = 0;

    % 4) f = x^2 + y^2, integral = pi/2
    tests(end+1).name    = 'f(x,y) = x^2 + y^2';
    tests(end  ).f       = @(x,y) x.^2 + y.^2;
    tests(end  ).I_exact = pi/2;

    % 5) f = x^2, integral = pi/4
    tests(end+1).name    = 'f(x,y) = x^2';
    tests(end  ).f       = @(x,y) x.^2;
    tests(end  ).I_exact = pi/4;

    % 6) f = (x^2 + y^2)^2 = r^4, integral = pi/3
    tests(end+1).name    = 'f(x,y) = (x^2 + y^2)^2';
    tests(end  ).f       = @(x,y) (x.^2 + y.^2).^2;
    tests(end  ).I_exact = pi/3;
end

%---------------------------------------------
% 1) Tabelki dla różnych N (oba mappingi)
%---------------------------------------------
function numtestTables(tests, mappings, N_list)
    for t = 1:numel(tests)
        myPrint('--- Test %d: %s ---\n', t, tests(t).name);
        myPrint('Dokładna całka I_exact = %.15g\n', ...
            tests(t).I_exact);

        for m = 1:numel(mappings)
            mapping = mappings{m};
            myPrint('  Mapping: %s\n', mapping);
            myPrint('    %6s  %20s  %20s  %12s  %12s\n', ...
                'N', 'I_num', '|I_num - I_exact|', ...
                'err(est)', 'time[s]');

            for N = N_list
                Nu = N;
                Nv = N;

                [I_num, err_est, t_exec] = P1Z18_ACZ_integrateDiskTrapezoid( ...
                    tests(t).f, Nu, Nv, mapping);
                abs_err = abs(I_num - tests(t).I_exact);

                myPrint(['    %6d  %20.12e  %20.12e  ' ...
                         '%12.3e  %12.3e\n'], ...
                    N, I_num, abs_err, err_est, t_exec);
            end

            myPrint('\n');
        end

        % Pauza między tabelkami a testem zbieżności
        pauseScreen();
        myPrint('\n');
    end
end

%---------------------------------------------
% 2) Analiza zbieżności błędu i ratio
%---------------------------------------------
function numtestConvergence(tests, mappings, makePlots)
    N_conv = 2.^(1:12);   % 2,4,8,...,4096

    for t = 1:numel(tests)
        myPrint('*** Analiza zbieżności błędu dla %s ***\n', ...
            tests(t).name);

        for m = 1:numel(mappings)
            mapping = mappings{m};
            myPrint('  Mapping: %s\n', mapping);
            myPrint('    %6s  %20s  %20s  %16s\n', ...
                'N', '|I_num - I_exact|', 'err(est)', ...
                'ratio(prev/cur)');

            prev_err      = NaN;
            abs_err_list  = zeros(size(N_conv));
            err_est_list  = zeros(size(N_conv));
            ratio_list    = NaN(size(N_conv));

            for k = 1:numel(N_conv)
                N  = N_conv(k);
                Nu = N;
                Nv = N;

                [I_num, err_est, ~] = P1Z18_ACZ_integrateDiskTrapezoid( ...
                    tests(t).f, Nu, Nv, mapping);
                abs_err = abs(I_num - tests(t).I_exact);

                abs_err_list(k) = abs_err;
                err_est_list(k) = err_est;

                ratioStr = '-';
                if ~isnan(prev_err) && isfinite(prev_err) ...
                        && isfinite(abs_err) ...
                        && prev_err > 0 && abs_err > 0
                    ratio = prev_err / abs_err;
                    ratio_list(k) = ratio;
                    ratioStr = sprintf('%.4f', ratio);
                end

                myPrint(['    %6d  %20.12e  %20.12e  ' ...
                         '%16s\n'], ...
                    N, abs_err, err_est, ratioStr);

                prev_err = abs_err;
            end

            myPrint('\n');

            % Wykres zbieżności dla danej funkcji i mapowania
            if makePlots
                makeConvergencePlot(N_conv, abs_err_list, ...
                    err_est_list, ratio_list, tests(t).name, ...
                    mapping);
            end

            if m < numel(mappings)
                pauseScreen();
                myPrint('\n');
            end
        end

        if t < numel(tests)
            pauseScreen();
            myPrint('\n');
        end
    end
end


%---------------------------------------------
% Pomocnicze drukowanie / pauza (wspólne)
%---------------------------------------------
function myPrint(varargin)
    fprintf(varargin{:});
end

function pauseScreen()
    input('--- Naciśnij Enter, aby kontynuować ---','s');
end

function makeConvergencePlot(N_vals, abs_err_list, ...
    err_est_list, ratio_list, fname, mapping)

    % Skala log_2 na osi X:
    x_vals = log2(N_vals);   % np. dla 2,4,8,... wyjdzie 1,2,3,...

    figure;
    yyaxis left;
    % Błędy w skali logarytmicznej (Y), X w skali log_2(N)
    semilogy(x_vals, abs_err_list, '-o');  % błąd absolutny
    hold on;
    semilogy(x_vals, err_est_list, '-x');  % błąd estymowany
    ylabel('Błąd (skala log Y)');

    yyaxis right;
    plot(x_vals, ratio_list, '-s');        % ratio w skali liniowej po Y
    ylabel('ratio(prev/cur)');

    % Oś X – opisujemy jako log_2(N)
    xlabel('log_2(N)');

    % Opcjonalnie: ładne ticki (tutaj 1,2,3,... odpowiadające 2,4,8,...)
    xticks(x_vals);
    xticklabels(arrayfun(@(v) sprintf('%.0f', v), x_vals, ...
        'UniformOutput', false));

    title(sprintf('Zbieżność błędu: %s, mapping = %s', ...
        fname, mapping), 'Interpreter', 'none');
    legend({'|I_{num} - I_{exact}|', 'err(est)', ...
        'ratio(prev/cur)'}, 'Location', 'best');

    grid on;
end

