function convexityVector = check_convexity(cells)

convexityVector = cells.previousVectors(:,1).*cells.nextVectors(:,2) - cells.nextVectors(:,1).*cells.previousVectors(:,2);

end