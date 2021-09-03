function uniques = get_uniques(vector,cellNumbers,zeroVec)

if numel(vector)
    zeroVec(vector) = 1;
    uniques = cellNumbers(logical(zeroVec(cellNumbers)));
else
    uniques = [];
end

end