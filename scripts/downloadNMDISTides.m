function T = downloadNMDISTides(sitecode,startDate,endDate)
% T = downloadNMDISTides(sitecode,startDate,endDate);
% Download hourly tidal predictions from NMDIS
%
% Example:
%
% T = downloadNMDISTides( ...
%     'T067', ...
%     datetime(2026,1,1), ...
%     datetime(2026,7,21));
%
% These data are from the Chinese National Marine Data Center:
% https://mds.nmdis.org.cn/pages/tidalCurrent.html
%
% Script developed by M. Williams & Microsoft CoPilot
% 21 July 2026

url = ...
    'https://mds.nmdis.org.cn/service/rdata/front/knowledge/chaoxidata/list';

options = weboptions( ...
    'MediaType','application/json', ...
    'ContentType','json', ...
    'Timeout',30);

Tall = table();

for d = startDate:endDate

    dateStr = datestr(d,'yyyy-mm-dd');

    payload.serchdate = dateStr;
    payload.sitecode  = sitecode;

    try

        data = webwrite(url,payload,options);

        F = data.data.filedata;

        eta = nan(24,1);

        for k = 0:23

            fld = sprintf('a%d',k);

            eta(k+1) = F.(fld);

        end

        % hourly timestamps

        % hourly timestamps (local time, UTC+8)

        timeLocal = dateshift(d,'start','day') + hours(0:23)';

        % UTC timestamps

        timeUTC = timeLocal - hours(8);

        Tday = table();

        Tday.time_UTCplus8 = timeLocal;
        Tday.time_UTC      = timeUTC;
        Tday.tide_cm       = eta;

        % Tday.time = time;
        Tday.tide_cm = eta;

        Tall = [Tall; Tday];

        fprintf('Downloaded %s\n',dateStr)

    catch ME

        fprintf('FAILED %s\n',dateStr)
        fprintf('%s\n',ME.message)

    end

end

Tall = sortrows(Tall,'time_UTC');

fname = sprintf('%s_%s_to_%s_tides.csv', ...
    sitecode, ...
    datestr(startDate,'yyyymmdd'), ...
    datestr(endDate,'yyyymmdd'));

writetable(Tall,fname)

fprintf('\nSaved:\n%s\n',fname)

T = Tall;

end