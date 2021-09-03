function angles = get_angles(vector1X, vector1Y, vector2X, vector2Y, vector1Lengths, vector2Lengths)

angles = real(acos(complex((vector1X.*vector2X + vector1Y.*vector2Y)./(vector1Lengths.*vector2Lengths))));

end