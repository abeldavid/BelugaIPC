function pid = isBelugaServerRunning()
%
% pid = isBelugaServerRunning()
%
% If Beluga server is running, returns its pid.  Otherwise returns 0.
%

beluga_daemon_path = fullfile(fileparts(mfilename('fullpath')), '../bin/beluga_daemon');
cmd = sprintf('%s pid', beluga_daemon_path);
[~, pid] = system(cmd);
pid = strtrim(pid);
line_breaks = strfind(pid, 10);
pid = str2double(pid(line_breaks(end) + 1 : end));