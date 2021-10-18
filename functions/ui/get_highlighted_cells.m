function d = get_highlighted_cells(app,d)

switch app.SpecialplotDropDown.Value
    case 'Normal'
        d.pl.highlightType = 0;
    case 'Highlight cells'
        d.pl.highlightType = 1;
        d.pl.highlightedCells = app.ChoosecellstohighlightListBox.Value;
        for i = 1:length(d.pl.highlightedCells)
            d.pl.highlightedCells{i} = str2double(d.pl.highlightedCells{i});
        end
        d.pl.highlightedCells = sort(cell2mat(d.pl.highlightedCells));
    case 'Show lineage'
        d.pl.highlightType = 2;
        d.pl.highlightedCells = app.ShowcelllineageListBox.Value;
        for i = 1:length(d.pl.highlightedCells)
            d.pl.highlightedCells{i} = str2double(d.pl.highlightedCells{i});
        end
        d.pl.highlightedCells = sort(cell2mat(d.pl.highlightedCells));
end
end