function pid = isBelugaServerRunning()
%
% pid = isBelugaServerRunning()
%
% If Beluga server is running, returns its pid.  Otherwise returns 0.
%

beluga_daemon_path = fullfile(fileparts(mfilename('fullpath')), '../bin/beluga_daemon');
cmd = sprintf('%s pid', beluga_daemon_path);
if ispc
    cmd = sprintf('ruby %s', cmd);
end
[~, pid] = system(cmd);
pid = strtrim(pid);
line_breaks = strfind(pid, 10);
if isempty(line_breaks),
    start = 1;
else
    start = line_breaks(end) + 1;
end
pid = str2double(pid(start : end));