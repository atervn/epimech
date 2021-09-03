function distances = calculate_distances(points1X,points1Y,points2X,points2Y,option)

if option
    distances = sqrt((points1X - points2X).^2 + (points1Y - points2Y).^2);
else
    distances = (points1X - points2X).^2 + (points1Y - points2Y).^2;
end

end