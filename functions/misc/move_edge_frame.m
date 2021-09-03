function d = move_edge_frame(d,dt)

d.simset.frame.cornersX = d.simset.frame.cornersX + 0.01.*dt.*[1 -1 -1 1]';
d.simset.frame.cornersY = d.simset.frame.cornersY + 0.01.*dt.*[1 1 -1 -1]';