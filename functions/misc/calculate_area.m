function area = calculate_area(verticesX,verticesY)

leftVerticesX = circshift(verticesX,-1,1);
leftVerticesY = circshift(verticesY,-1,1);

area = sum(0.5.*(verticesX.*leftVerticesY - leftVerticesX.*verticesY));

end