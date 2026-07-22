function T = downloadWunderground(stationID, startDate, endDate, apiKey)

% DOWNLOADWUNDERGROUND Downloads Wunderground.com historical observations
%
% Example:
%
% apiKey = 'e1f10a1e78da46f5b10a1e78da96f525';
%
% T = downloadWunderground('ZSSS:9:CN', ...
%         datetime(2026,1,1), ...
%         datetime(2026,12,31), ...
%         apiKey);
%
% A CSV file will be saved automatically.

Tall = table();

dates = startDate:endDate;

for d = dates

    dateStr = datestr(d,'yyyymmdd');

    % don't download data in the future:
    todayStr = datestr(datetime('today'),'yyyymmdd');
    if str2double(dateStr) > str2double(todayStr)

        fprintf('Reached future date: %s\n',dateStr);
        break

    end


    url = sprintf([ ...
        'https://api.weather.com/v1/location/%s/' ...
        'observations/historical.json?' ...
        'apiKey=%s&units=e&startDate=%s&endDate=%s'], ...
        stationID, apiKey, dateStr, dateStr);

    try

        success = false;

        for attempt = 1:3

            try

                data = webread(url);

                success = true;
                break

            catch ME

                fprintf('Attempt %d failed\n',attempt);

                if attempt < 3
                    pause(5)
                end

            end

        end

        if ~success
            error('Failed after 3 attempts');
        end
        obs = data.observations;

        if isempty(obs)
            fprintf('No data: %s\n',dateStr);
            continue
        end

        n = numel(obs);

        Tday = table();

        %------------------------------------------------------------------
        % Time
        %------------------------------------------------------------------
        Tday.time = datetime([obs.valid_time_gmt]', ...
            'ConvertFrom','posixtime', ...
            'TimeZone','UTC');

        % Uncomment if preferred:
        % Tday.time.TimeZone = 'Asia/Shanghai';

        %------------------------------------------------------------------
        % Always-present variables
        %------------------------------------------------------------------
        Tday.temp       = [obs.temp]';
        Tday.dewPt      = [obs.dewPt]';
        Tday.rh         = [obs.rh]';
        Tday.pressure   = [obs.pressure]';
        Tday.vis        = [obs.vis]';
        Tday.wspd       = [obs.wspd]';
        Tday.heat_index = [obs.heat_index]';
        Tday.feels_like = [obs.feels_like]';

        %------------------------------------------------------------------
        % Variables that sometimes contain null
        %------------------------------------------------------------------
        Tday.wdir         = nan(n,1);
        Tday.gust         = nan(n,1);
        Tday.precip_hrly  = nan(n,1);
        Tday.precip_total = nan(n,1);


        for k = 1:n

            Tday.wdir(k)         = getNumericField(obs(k),'wdir');
            Tday.gust(k)         = getNumericField(obs(k),'gust');
            Tday.precip_hrly(k)  = getNumericField(obs(k),'precip_hrly');
            Tday.precip_total(k) = getNumericField(obs(k),'precip_total');

        end

        %------------------------------------------------------------------
        % Text variables
        %------------------------------------------------------------------
        Tday.wx_phrase      = string({obs.wx_phrase}');
        Tday.wdir_cardinal  = string({obs.wdir_cardinal}');
        Tday.clds           = string({obs.clds}');

        Tall = [Tall; Tday];

        fprintf('Downloaded %s (%d obs)\n', ...
            dateStr,height(Tday));

    catch ME

        fprintf('FAILED %s\n',dateStr);
        fprintf('%s\n',ME.message);

    end

end

%----------------------------------------------------------------------
% Sort by time
%----------------------------------------------------------------------
Tall = sortrows(Tall,'time');

%----------------------------------------------------------------------
% Save CSV
%----------------------------------------------------------------------
fname = sprintf('%s_%s_to_%s.csv', ...
    strrep(stationID,':','_'), ...
    datestr(startDate,'yyyymmdd'), ...
    datestr(endDate,'yyyymmdd'));

floc = '../external_data/';

writetable(Tall,[floc,fname]);

fprintf('\nSaved:\n%s\n',fname);

T = Tall;

end



function val = getNumericField(s, fieldName)

if isfield(s, fieldName) && ...
        isnumeric(s.(fieldName)) && ...
        ~isempty(s.(fieldName))

    val = s.(fieldName);

else

    val = NaN;

end

end