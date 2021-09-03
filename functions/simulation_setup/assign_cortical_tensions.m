function cells = assign_cortical_tensions(app, cells, spar)


switch app.modelCase
    case 'new'
        for k = 1:length(cells)
            cells(k).corticalTension = spar.fCortex;
            cells(k).perimeterConstant = spar.perimeterConstant;
        end
    case 'loaded'
        for k = 1:length(cells)
            if exist([app.import.folderName '/cortical_tension/'],'file') == 7
                cells(k).corticalTension = cells(k).corticalTension*app.import.systemParameters.eta/app.systemParameters.eta;
                cells(k).perimeterConstant = spar.perimeterConstant;
                if app.cellParameters.fCortex ~= app.import.cellParameters.fCortex
                    cells(k).corticalTension = cells(k).corticalTension*spar.fCortex/cells(k).corticalTension;
                    cells(k).perimeterConstant = spar.perimeterConstant;
                end
            else
                cells(k).corticalTension = spar.fCortex;
                cells(k).perimeterConstant = spar.perimeterConstant;
            end
        end
end