function d = rescale_imported_parameters(app,d)
% RESCALE_IMPORTED_PARAMETERS Rescale the imported parameters
%   The function rescales some of the cell specific parameters in case the
%   eta, scaling length or scaling time has changed compared to the
%   imported simulation.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% rescale the normal area (only affects with uniform cell area)
d.spar.normArea = app.import.scaledParameters.normArea*app.import.scaledParameters.scalingLength^2/app.systemParameters.scalingLength^2;

% rescale the normal boundary vertex separation
d.spar.membraneLength = app.import.scaledParameters.membraneLength*app.import.scaledParameters.scalingLength/app.systemParameters.scalingLength;

% go through the cells
for k = 1:length(d.cells)

    % rescale the fCortex
    d.cells(k).cortex.fCortex = d.cells(k).cortex.fCortex*app.import.scaledParameters.eta/app.import.scaledParameters.scalingTime*app.systemParameters.scalingTime/app.systemParameters.eta;
    
    % if fCortex has been modified from the original value, scale the old
    % value to obtain the new one
    d.cells(k).cortex.fCortex = d.cells(k).cortex.fCortex*app.cellParameters.fCortex/app.import.cellParameters.fCortex;

    % rescale the normal cell area
    d.cells(k).area = d.cells(k).area*app.import.scaledParameters.scalingLength^2/app.systemParameters.scalingLength^2;
    
    % rescale the normal cell perimeter
    d.cells(k).perimeter = d.cells(k).perimeter*app.import.scaledParameters.scalingLength/app.systemParameters.scalingLength;
    
    % rescale the possible division target area and daugter cell new areas
    d.cells(k).division.targetArea = d.cells(k).division.targetArea*app.import.scaledParameters.scalingLength^2/app.systemParameters.scalingLength^2;
    d.cells(k).division.newAreas = d.cells(k).division.newAreas*app.import.scaledParameters.scalingLength^2/app.systemParameters.scalingLength^2;
    
    % rescale the focal adhesion strengths
    if (strcmp(app.import.simulationType,'pointlike') || strcmp(app.import.simulationType,'opto') || strcmp(app.import.simulationType,'stretch')) && app.UseimportedsubstratedataCheckBox.Value
        d.cells(k).substrate.fFocalAdhesions = d.cells(k).substrate.fFocalAdhesions.*app.import.systemParameters.eta./app.import.systemParameters.scalingTime.*app.systemParameters.scalingTime./app.systemParameters.eta/app.import.scaledParameters.membraneLength*d.spar.membraneLength;
    end
end

end