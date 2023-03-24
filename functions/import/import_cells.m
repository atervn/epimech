function cells = import_cells(app,d,option,varargin)
% IMPORT_CELLS Import cell data for simulation or plotting
%   The function loads the required cell data from the unzipped files and
%   creates the cell data structure.
%   INPUT:
%       app: main application data structure
%       option: variable to indicate the type of import
%       varargin: can be used to indicate a time point to load that differs
%           from the selected one
%   OUTPUT:
%       cells: cell data structure
%   by Aapo Tervonen, 2021


% initialize the cell structure
cells = initialize_cells_struct;

% get the import folder name and current time point
switch app.appTask
    
    % simulation
    case 'simulate'
        folderName = app.import.folderName;
        timePoint = app.import.currentTimePoint;
        
        % plotting or analysis
    case 'plotAndAnalyze'
        folderName = app.plotImport(app.selectedFile).folderName;
        
        % use the additional imput to select some other time point to load
        if numel(varargin) > 0 && isnumeric(varargin{1}) && mod(varargin{1},1) == 0
            timePoint = 1;
        else
            timePoint = app.plotImport(app.selectedFile).currentTimePoint;
        end
end

% temporary struct to indicate if focal adhesions, junctions and lineage
% are imported
importTemp.focalAdhesions = (strcmp(option, 'simulation') && (strcmp(app.import.simulationType,'pointlike') || strcmp(app.import.simulationType,'opto') || strcmp(app.import.simulationType,'stretch')) && app.UseimportedsubstratedataCheckBox.Value) || (strcmp(option, 'post_plotting') && app.importPlottingOptions.focalAdhesions);
importTemp.junctions = strcmp(option, 'simulation') || (strcmp (option, 'post_plotting') && (app.importPlottingOptions.junctions || app.importPlottingOptions.cellStyle == 3 || app.importPlottingOptions.cellStyle == 5)) || strcmp(option,'get_neighbors') || strcmp(option,'opto_analysis');
importTemp.lineage = strcmp(option, 'simulation') || strcmp(app.SpecialplotDropDown.Value,'Show lineage');

% load the cell data from files
importedData = read_cell_data(app, d, importTemp, folderName, timePoint, option);

% get the number of cells
nCells = size(importedData.vertices,2)/2;

% go through the cells
for k = 1:nCells
    
    % get the vertex coordinates for cell k
    vertices = importedData.vertices(:,1+2*(k-1):2+2*(k-1));
    cells(k).nVertices = nnz(vertices(:,1));
    vertices = vertices(1:cells(k).nVertices,:);
    cells(k).verticesX = vertices(:,1);
    cells(k).verticesY = vertices(:,2);
    
    % get the cell state, vertex states, normal area and perimeter
    cells(k).cellState = importedData.cellStates(k);
    cells(k).vertexStates = importedData.vertexStates(1:cells(k).nVertices,k);
    cells(k).normArea = importedData.normProperties(1,k);
    cells(k).normPerimeter = importedData.normProperties(2,k);
    
    % if simulation
    if strcmp(option, 'simulation')
        
        % get the cell division state
        cells(k).division.state = importedData.divisionStates(k);
        
        % get the division vertices, distances, new areas and target area
        % if growth simulation
        if strcmp(app.simulationType, 'growth')
            cells(k).division.vertices = importedData.divisionVertices(:,k);
            cells(k).division.distanceSq = importedData.divisionDistances(k);
            cells(k).division.newAreas = importedData.newAreas(:,k);
            cells(k).division.targetArea = importedData.targetAreas(1,k);
            cells(k).division.time = importedData.divisionTimes(k) - (timePoint-1)*app.import.systemParameters.scalingTime*app.import.exportOptions.exportDt;
        else
            cells(k).division.vertices = [0;0];
            cells(k).division.distanceSq = 0;
            cells(k).division.newAreas = [0;0];
            cells(k).division.targetArea = 0;
            cells(k).division.time = 0;
        end
        
        % get the cortical data if it is available
        if exist([app.import.folderName '/cortex/'],'file') == 7 || exist([app.import.folderName '/cortical_tension/'],'file') == 7
            cells(k).cortex.vertexMultipliers = importedData.vertexMultipliers(1:cells(k).nVertices,k);
            cells(k).cortex.fCortex = importedData.corticalStrengths(1,k);
            cells(k).cortex.perimeterConstant = importedData.perimeterConstants(1,k);
        else
            cells(k).cortex.vertexMultipliers = ones(length(cells(k).verticesX),1);
            cells(k).cortex.fCortex = d.spar.fCortex;
            cells(k).cortex.perimeterConstant = d.spar.perimeterConstant;
        end
        
        % calculate the boundary vectors, lengths, area, perimeter and
        % vertex angles
        cells(k) = get_boundary_vectors(cells(k));
        cells(k) = get_boundary_lengths(cells(k));
        cells(k) = get_cell_areas(cells(k));
        cells(k) = get_cell_perimeters(cells(k));
        cells(k) = get_vertex_angles(cells(k));
        
        % set the empty cell propreties
        cells(k) = set_empty_cell_properties(cells(k));
    end
    
    % if junctions are imported
    if importTemp.junctions
        
        % get the junction data
        % LEGACY
        if isfield(importedData, 'junctions') && size(importedData.junctions,2) == 4*nCells
            cells(k).junctions.cells = importedData.junctions(1:cells(k).nVertices,1+4*(k-1):2+4*(k-1));
            cells(k).junctions.vertices = importedData.junctions(1:cells(k).nVertices,3+4*(k-1):4+4*(k-1));
        else
            cells(k).junctions.cells = [importedData.junctions(1:cells(k).nVertices,1+2*(k-1)) zeros(cells(k).nVertices,1)];
            cells(k).junctions.vertices = [importedData.junctions(1:cells(k).nVertices,2+2*(k-1)) zeros(cells(k).nVertices,1)];
        end
    end
    
    % if focal adhesions are imported
    if importTemp.focalAdhesions
        cells(k).substrate.connected = logical(importedData.FAConnected(1:cells(k).nVertices,k));
        nConnected = sum(cells(k).substrate.connected);
        cells(k).substrate.points = importedData.FAPoints(1:nConnected,1+3*(k-1):3+3*(k-1));
        cells(k).substrate.pointsLin = cells(k).substrate.points(:);
        cells(k).substrate.weights = importedData.FAWeights(1:nConnected,1+3*(k-1):3+3*(k-1));
        cells(k).substrate.weightsLin = cells(k).substrate.weights(:);
        cells(k).substrate.matrixIdx = importedData.FAMatrixIdx(1:nConnected*3,k);
        cells(k).substrate.linkCols = importedData.FALinkCols(1:nConnected,1+3*(k-1):3+3*(k-1));
        cells(k).substrate.fFocalAdhesions = importedData.FAStrengths(1:nConnected,k);
    end
    
    
    % if a cell forces are plotted, get the force vectors
    if strcmp (option, 'post_plotting')
        
        if app.importPlottingOptions.cellForcesTotal
            tempData = importedData.totalForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.totalX = tempData(:,1);
            cells(k).forces.totalY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesCortical
            tempData = importedData.corticalForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.corticalX = tempData(:,1);
            cells(k).forces.corticalY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesJunctions
            tempData = importedData.junctionForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.junctionX = tempData(:,1);
            cells(k).forces.junctionY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesDivision
            tempData = importedData.divisionForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.divisionX = tempData(:,1);
            cells(k).forces.divisionY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesMembrane
            tempData = importedData.membraneForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.membraneX = tempData(:,1);
            cells(k).forces.membraneY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesContact
            tempData = importedData.contactForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.contactX = tempData(:,1);
            cells(k).forces.contactY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesArea
            tempData = importedData.areaForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.areaX = tempData(:,1);
            cells(k).forces.areaY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesPointlike
            tempData = importedData.pointlikeForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.pointlikeX = tempData(:,1);
            cells(k).forces.pointlikeY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesFocalAdhesions
            tempData = importedData.substrateForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.substrateX = tempData(:,1);
            cells(k).forces.substrateY = tempData(:,2);
        end
    end
    
    % if lineage is imported
    if importTemp.lineage
        cells(k).lineage = nonzeros(importedData.lineages(:,k))';
    end
end

% if additional junction data is needed, derived it from the main data
if strcmp(option, 'post_plotting') && (app.importPlottingOptions.junctions || app.importPlottingOptions.cellStyle == 3 || app.importPlottingOptions.cellStyle == 5)
    cells = get_junction_data(cells);
end

end