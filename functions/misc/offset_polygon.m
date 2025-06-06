function new = offset_polygon(old, d)

x = old(:,1)';
y = old(:,2)';
n = length(x);
xNew = zeros(n, 1);
yNew = zeros(n, 1);

for i = 1:n
    % Get previous, current, and next points
    iPrev = mod(i-2, n) + 1;
    iNext = mod(i, n) + 1;
    
    % Edge vectors
    v1 = [x(i) - x(iPrev), y(i) - y(iPrev)];
    v2 = [x(iNext) - x(i), y(iNext) - y(i)];
    
    % Normalize and rotate 90° to get normals
    n1 = [-v1(2), v1(1)] / norm(v1);
    n2 = [-v2(2), v2(1)] / norm(v2);
    
    % Bisector direction
    bisector = (n1 + n2);
    bisector = bisector / norm(bisector);
    
    % Angle between edges
    angle = acos(dot(n1, bisector));
    moveDist = d / sin(angle);
    
    % Offset point
    xNew(i) = x(i) + moveDist * bisector(1);
    yNew(i) = y(i) + moveDist * bisector(2);
end

new = [xNew yNew];

end