clear
clc

apiKey = 'e1f10a1e78da46f5b10a1e78da96f525';

dates = datetime(2026,5,25):datetime(2026,5,31);

Tall = table();

for d = dates

    dateStr = datestr(d,'yyyymmdd');

    url = sprintf([ ...
        'https://api.weather.com/v1/location/' ...
        'ZSSS:9:CN/observations/historical.json?' ...
        'apiKey=%s&units=e&startDate=%s&endDate=%s'], ...
        apiKey,dateStr,dateStr);

    fprintf('\n=============================\n');
    fprintf('Date: %s\n',dateStr);

    try

        data = webread(url);

        obs = data.observations;

        fprintf('Observations: %d\n',length(obs));

        T = struct2table(obs);

        fprintf('Class(wdir) = %s\n',class(T.wdir));
        fprintf('Class(gust) = %s\n',class(T.gust));

        % Optional: inspect all variable classes
        disp(varfun(@class,T,'OutputFormat','table'))

        % Try concatenation
        if isempty(Tall)
            Tall = T;
            fprintf('Initialized Tall\n');
        else
            fprintf('Appending...\n');
            Tall = [Tall; T];
            fprintf('Success\n');
        end

    catch ME

        fprintf('FAILED\n');
        fprintf('%s\n',ME.message);

    end

end