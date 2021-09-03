function cells = set_division_times(cells,simset,spar,nCells)

for k = 1:nCells
    if any(simset.divisionType == [1,2])
        cells(k).division.time = spar.divisionTimeMean + randn*spar.divisionTimeSD;
    else
        cells(k).division.time = 0;
        cells(k).division.state = -1;
    end
end