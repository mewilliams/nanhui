

clear
close

apiKey = 'e1f10a1e78da46f5b10a1e78da96f525';

dates = datetime(2026,1,1):datetime(2026,12,31);

Tall = table();

for d = dates

    dateStr = datestr(d,'yyyymmdd');

    url = sprintf(['https://api.weather.com/v1/location/' ...
        'ZSSS:9:CN/observations/historical.json?' ...
        'apiKey=%s&units=e&startDate=%s&endDate=%s'], ...
        apiKey,dateStr,dateStr);

    try

        data = webread(url);

        T = struct2table(data.observations);

        T.time = datetime(T.valid_time_gmt,...
            'ConvertFrom','posixtime',...
            'TimeZone','UTC');

        T.time.TimeZone = 'Asia/Shanghai';

        Tall = [Tall; T];

        fprintf('Downloaded %s\n',dateStr)

    catch ME

        fprintf('Failed %s\n',dateStr)
        fprintf('%s\n',ME.message)

    end

end

writetable(Tall,'Shanghai_2026.csv')