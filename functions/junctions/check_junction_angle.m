function junctions2Remove = check_junction_angle(spar,cells,linkedIdx,pairVerticesX,pairVerticesY,functionCase)

if functionCase == 1
    junctions2Remove = linkedIdx;
elseif functionCase == 2
    junctions2Remove = (1:length(pairVerticesX))';
end

junctionVectorsX = pairVerticesX - cells.verticesX(linkedIdx);
junctionVectorsY = pairVerticesY - cells.verticesY(linkedIdx);

junctionAngles = atan2(junctionVectorsY, junctionVectorsX) - atan2(-cells.rightVectorsY(linkedIdx), -cells.rightVectorsX(linkedIdx));
negatives = junctionAngles < 0;
junctionAngles(negatives) = junctionAngles(negatives) + 2*pi;

halfAngles = cells.outsideAngles(linkedIdx)./2;

badJunctions = abs(halfAngles - junctionAngles) > spar.maxJunctionAngleConstant*halfAngles;

junctions2Remove = junctions2Remove(badJunctions);

end