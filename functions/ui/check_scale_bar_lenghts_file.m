function ok = check_scale_bar_lenghts_file(scaleBarData)
% CHECK_SCALE_BAR_LENGTHS Check that scale bar lengths are defined
% correctly
%   The function checks the imported scale bar settings.
%   INPUT:
%       scaleBarData: importd scale bar data
%   OUTPUT:
%       ok: data is ok
%   by Aapo Tervonen, 2021

% by default, all is fine
ok = 1;

% if there are other than 3 columns in the matrix, give error and return
if size(scaleBarData,2) ~= 3
    ok = 0; return
end

% go through the rows
for i = 1:size(scaleBarData,1)
    
    % if the second element is larger than the third, give error and return
    if scaleBarData(i,2) >= scaleBarData(i,3)
        ok = 0; return
    end
    
    % if this is not the last row
    if i < size(scaleBarData,1)
        
        % if the upper range limit does not equal the lower range limit of
        % the next row, give error and return
        if scaleBarData(i,3) ~= scaleBarData(i+1,2)
            ok = 0; return
        end
    end
end

end