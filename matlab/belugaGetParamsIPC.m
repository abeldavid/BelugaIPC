function params_out = belugaGetParamsIPC(sock)

if nargin == 0,
    sock = [];
end

params_out = belugaIPCMessage('get params', sock);