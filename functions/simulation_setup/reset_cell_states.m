function cells = reset_cell_states(app,cells)

if strcmp(app.ResetcellstatesMenu.Checked,'on')
    for k = 1:length(cells)
        cells(k).cellState = 0;
    end
end