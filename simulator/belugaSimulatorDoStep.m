function [x_o, y_o, z_o] = belugaSimulatorDoStep(go_x, go_y, go_z)

persistent x;
persistent y;
persistent z;
persistent th;
persistent v;

if isempty(x),
    x = 0;
    y = 0;
    z = 0;
    th = 0;
    v = 0.05;
end

rmax = 3.2;
zmax = 2.3;

kth = -0.1;
kz = 0.1;

vmax = 0.05;
dr1 = 0.5;

dx = go_x - x;
dy = go_y - y;
dz = go_z - z;

dr = sqrt(dx^2 + dy^2);

th = th + kth*sin(th - atan2(dy,dx));

if(dr > dr1)
    v = vmax;
else
    v = vmax*(dr/dr1);
end

x = x + v*cos(th);
y = y + v*sin(th);

z = z + kz*dz;

r = sqrt(x.^2 + y.^2);
if r > rmax,
    % this is not an exact collision correction
    phi = atan2(y,x);
    rnew = rmax - (r - rmax);
    x = rnew*cos(phi);
    y = rnew*sin(phi);
    v_vec = [v*cos(th); v*sin(th)];
    v_radial = [cos(phi) sin(phi)]*v_vec;
    v_perp = [-sin(phi) cos(phi)]*v_vec;
    v_vec_new = -v_radial*[cos(phi); sin(phi)] + v_perp*[-sin(phi); cos(phi)];
    th = atan2(v_vec_new(2), v_vec_new(1));
end

if(z < 0)
    z = 0;
end
if(z > zmax)
    z = zmax;
end

x_o = x;
y_o = y;
z_o = z;