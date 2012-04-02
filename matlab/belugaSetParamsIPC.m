function params_out = belugaSetParamsIPC(params, sock)

if nargin == 1,
    sock = [];
end

params_out = belugaIPCMessage(['set params "' params '"'], sock);