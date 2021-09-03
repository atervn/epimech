function color = get_neighbor_color(neighbors)

if neighbors <= 1
    color = [0.6 0.73 0.62];
elseif neighbors <= 2
    color = [0.71 0.69 0.55];
elseif neighbors <= 3
    color = [0.71 0.59 0.55];
elseif neighbors <= 4
    color = [0.71 0.55 0.59];
elseif neighbors <= 5
    color = [0.5 0.59 0.71];
elseif neighbors <= 6
    color = [0.59 0.63 0.71];
elseif neighbors <= 7
    color = [0.55 0.69 0.70];
else
    color = [0.40 0.45 0.41];
end