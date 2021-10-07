function cells = import_cells(app,option,varargin)

cells = initialize_cells_struct;

switch app.appTask
    case 'simulate'
        folderName = app.import.folderName;
        currentTimePoint = app.import.currentTimePoint;
    case 'plotAndAnalyze'
        folderName = app.plotImport(app.selectedFile).folderName;
        currentTimePoint = app.plotImport(app.selectedFile).currentTimePoint;
        % for displacement plotting, the initial state
        if numel(varargin) > 0 && strcmp(varargin{1},'initial')
            currentTimePoint = 1;
        end
end

importedVertices = csvread([folderName '/vertices/vertices_' num2str(currentTimePoint), '.csv']);
importedCellStates = csvread([folderName '/cell_states/cell_states_' num2str(currentTimePoint), '.csv']);
importedVertexStates = csvread([folderName '/vertex_states/vertex_states_' num2str(currentTimePoint), '.csv']);
importedNormProperties = csvread([folderName '/norm_properties/norm_properties_' num2str(currentTimePoint), '.csv']);
if strcmp(option, 'simulation')
    importedJunctions = csvread([folderName '/junctions/junctions_' num2str(currentTimePoint), '.csv']);
    importedDivisionStates = csvread([folderName '/division/states_' num2str(currentTimePoint), '.csv']);
    if strcmp(app.import.simulationType,'growth')
        importedDivisionVertices = csvread([folderName '/division/vertices_' num2str(currentTimePoint), '.csv']);
        importedDivisionDistances = csvread([folderName '/division/distances_' num2str(currentTimePoint), '.csv']);
        importedNewAreas = csvread([folderName '/division/new_areas_' num2str(currentTimePoint), '.csv']);
        importedTargetAreas = csvread([folderName '/division/target_areas_' num2str(currentTimePoint), '.csv']);
    end
    importedNormProperties = csvread([folderName '/norm_properties/norm_properties_' num2str(currentTimePoint), '.csv']);
    importedLineages = csvread([folderName '/lineage/lineage_' num2str(currentTimePoint), '.csv']);

    if exist([app.import.folderName '/cortical_tension/'],'file') == 7
        importedVertexCorticalTensions = csvread([folderName '/cortical_tension/vertex_cortical_tensions_' num2str(currentTimePoint), '.csv']);
        importedCorticalTensions = csvread([folderName '/cortical_tension/cortical_tensions_' num2str(currentTimePoint), '.csv']);
        importedCorticalConstants = csvread([folderName '/cortical_tension/cortical_constants_' num2str(currentTimePoint), '.csv']);
    end

    if  strcmp(app.import.simulationType,'pointlike') && app.UseimportedsubstratedataCheckBox.Value
        importedFAPoints = csvread([folderName '/focal_adhesions/focal_adhesion_points_' num2str(currentTimePoint), '.csv']);
        importedFAConnected = csvread([folderName '/focal_adhesions/focal_adhesion_connected_' num2str(currentTimePoint), '.csv']);
        importedFAWeights = csvread([folderName '/focal_adhesions/focal_adhesion_weights_' num2str(currentTimePoint), '.csv']);
        importedFALinkCols = csvread([folderName '/focal_adhesions/focal_adhesion_link_cols_' num2str(currentTimePoint), '.csv']);
        importedFAMatrixIdx = csvread([folderName '/focal_adhesions/focal_adhesion_matrix_idx_' num2str(currentTimePoint), '.csv']);
        importedFAStrengths = csvread([folderName '/focal_adhesions/focal_adhesion_strengths_' num2str(currentTimePoint), '.csv']);
    end
    
elseif strcmp (option, 'post_plotting')
    
    if  app.importPlottingOptions.focalAdhesions
        importedFAPoints = csvread([folderName '/focal_adhesions/focal_adhesion_points_' num2str(currentTimePoint), '.csv']);
        importedFAConnected = csvread([folderName '/focal_adhesions/focal_adhesion_connected_' num2str(currentTimePoint), '.csv']);
        importedFAWeights = csvread([folderName '/focal_adhesions/focal_adhesion_weights_' num2str(currentTimePoint), '.csv']);
        importedFALinkCols = csvread([folderName '/focal_adhesions/focal_adhesion_link_cols_' num2str(currentTimePoint), '.csv']);
        importedFAMatrixIdx = csvread([folderName '/focal_adhesions/focal_adhesion_matrix_idx_' num2str(currentTimePoint), '.csv']);
        importedFAStrengths = csvread([folderName '/focal_adhesions/focal_adhesion_strengths_' num2str(currentTimePoint), '.csv']);
    end
    
    if app.importPlottingOptions.junctions || app.importPlottingOptions.cellStyle == 3 || app.importPlottingOptions.cellStyle == 5
        importedJunctions = csvread([folderName '/junctions/junctions_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesTotal %&& exist([folderName '/cell_forces'],'folder') == 2
        importedTotalForces = csvread([folderName '/cell_forces/total/total_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesCortical
        importedCorticalForces = csvread([folderName '/cell_forces/cortical/cortical_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesJunctions
        importedJunctionForces = csvread([folderName '/cell_forces/junction/junction_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesDivision
        importedDivisionForces = csvread([folderName '/cell_forces/division/division_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesMembrane
        importedMembraneForces = csvread([folderName '/cell_forces/membrane/membrane_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesContact
        importedContactForces = csvread([folderName '/cell_forces/contact/contact_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesArea
        importedAreaForces = csvread([folderName '/cell_forces/area/area_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesPointlike
        importedPointlikeForces = csvread([folderName '/cell_forces/pointlike/pointlike_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.cellForcesFocalAdhesions
        importedSubstrateForces = csvread([folderName '/cell_forces/focal_adhesion/focal_adhesion_' num2str(currentTimePoint), '.csv']);
    end
    if app.importPlottingOptions.focalAdhesions
        importedFocalAdhesions = csvread([folderName '/focal_adhesions/focal_adhesion_points_' num2str(currentTimePoint), '.csv']);
        importedFocalAdhesionConnected = csvread([folderName '/focal_adhesions/focal_adhesion_connected_' num2str(currentTimePoint), '.csv']);
    end
    if strcmp(app.SpecialplotDropDown.Value,'Show lineage')
        importedLineages = csvread([folderName '/lineage/lineage_' num2str(currentTimePoint), '.csv']);
    end
elseif strcmp(option,'get_neighbors')
    importedJunctions = csvread([folderName '/junctions/junctions_' num2str(currentTimePoint), '.csv']);
elseif strcmp(option,'opto_analysis')
    importedJunctions = csvread([folderName '/junctions/junctions_' num2str(currentTimePoint), '.csv']);
end

nCells = size(importedVertices,2)/2;

if exist('importedJunctions','var') && size(importedJunctions,2) == 2*nCells
    newImport = 0;
else
    newImport = 1;
end


for k = 1:nCells
   
    vertices = importedVertices(:,1+2*(k-1):2+2*(k-1));
    cells(k).nVertices = nnz(vertices(:,1));
    vertices = vertices(1:cells(k).nVertices,:);
    cells(k).verticesX = vertices(:,1);
    cells(k).verticesY = vertices(:,2);
    cells(k).cellState = importedCellStates(k);
    cells(k).vertexStates = importedVertexStates(1:cells(k).nVertices,k);
    cells(k).normArea = importedNormProperties(1,k);
    cells(k).normPerimeter = importedNormProperties(2,k);
    if strcmp(option, 'simulation')
        
        if newImport
            cells(k).junctions.cells = importedJunctions(1:cells(k).nVertices,1+4*(k-1):2+4*(k-1));
            cells(k).junctions.vertices = importedJunctions(1:cells(k).nVertices,3+4*(k-1):4+4*(k-1));
        else
            cells(k).junctions.cells = [importedJunctions(1:cells(k).nVertices,1+2*(k-1)) zeros(cells(k).nVertices,1)];
            cells(k).junctions.vertices = [importedJunctions(1:cells(k).nVertices,2+2*(k-1)) zeros(cells(k).nVertices,1)];
        end
        
        cells(k).division.state = importedDivisionStates(k);
        if exist([app.import.folderName '/cortical_tension/'],'file') == 7
            cells(k).vertexCorticalTensions = importedVertexCorticalTensions(1:cells(k).nVertices,k);
            cells(k).corticalTension = importedCorticalTensions(1,k);
            cells(k).corticalConstant = importedCorticalConstants(1,k);
        end
        cells(k).lineage = nonzeros(importedLineages(:,k))'; 
        if strcmp(app.simulationType, 'growth')
            cells(k).division.vertices = importedDivisionVertices(:,k);
            cells(k).division.distanceSq = importedDivisionDistances(k);
            cells(k).division.newAreas = importedNewAreas(:,k);
            cells(k).division.targetArea = importedTargetAreas(1,k);
        else
            cells(k).division.vertices = [0;0];
            cells(k).division.newAreas = [0;0];
            cells(k).division.targetArea = 0;
        end
        if ~exist([folderName '/areas'],'dir') == 7
            cells(k).normArea = importedNormProperties(1,k);
            cells(k).normPerimeter = importedNormProperties(2,k);
        end
        
        cells(k) = get_boundary_vectors(cells(k));
        cells(k) = get_boundary_lengths(cells(k));
        cells(k) = get_cell_areas(cells(k));
        cells(k) = get_cell_perimeters(cells(k));
        cells(k) = get_vertex_angles(cells(k));
        
        cells(k) = set_empty_cell_properties(cells(k));
        
        if  strcmp(app.import.simulationType,'pointlike') && app.UseimportedmatrixdataCheckBox.Value
            cells(k).substrate.connected = logical(importedFAConnected(1:cells(k).nVertices,k));
            nConnected = sum(cells(k).substrate.connected);
            cells(k).substrate.points = importedFAPoints(1:nConnected,1+3*(k-1):3+3*(k-1));
            cells(k).substrate.pointsLin = cells(k).substrate.points(:);            
            cells(k).substrate.weights = importedFAWeights(1:nConnected,1+3*(k-1):3+3*(k-1));
            cells(k).substrate.weightsLin = cells(k).substrate.weights(:);
            cells(k).substrate.matrixIdx = importedFAMatrixIdx(1:nConnected*3,k);
            cells(k).substrate.linkCols = importedFALinkCols(1:nConnected,1+3*(k-1):3+3*(k-1));    
            % rescaled for the new settings
            cells(k).substrate.fFocalAdhesions = importedFAStrengths(1:nConnected,k).*app.import.systemParameters.eta./app.import.systemParameters.scalingTime.*app.systemParameters.scalingTime./app.systemParameters.eta;
        end
        
    elseif strcmp (option, 'post_plotting')
        if app.importPlottingOptions.focalAdhesions
            cells(k).substrate.connected = logical(importedFAConnected(1:cells(k).nVertices,k));
            nConnected = sum(cells(k).substrate.connected);
            cells(k).substrate.points = importedFAPoints(1:nConnected,1+3*(k-1):3+3*(k-1));
            cells(k).substrate.pointsLin = cells(k).substrate.points(:);            
            cells(k).substrate.weights = importedFAWeights(1:nConnected,1+3*(k-1):3+3*(k-1));
            cells(k).substrate.weightsLin = cells(k).substrate.weights(:);
            cells(k).substrate.matrixIdx = importedFAMatrixIdx(1:nConnected*3,k);
            cells(k).substrate.linkCols = importedFALinkCols(1:nConnected,1+3*(k-1):3+3*(k-1));      
        end
        
        if app.importPlottingOptions.junctions || app.importPlottingOptions.cellStyle == 3 || app.importPlottingOptions.cellStyle == 5
            if newImport
                cells(k).junctions.cells = importedJunctions(1:cells(k).nVertices,1+4*(k-1):2+4*(k-1));
                cells(k).junctions.vertices = importedJunctions(1:cells(k).nVertices,3+4*(k-1):4+4*(k-1));
            else
                cells(k).junctions.cells = [importedJunctions(1:cells(k).nVertices,1+2*(k-1)) zeros(cells(k).nVertices,1)];
                cells(k).junctions.vertices = [importedJunctions(1:cells(k).nVertices,2+2*(k-1)) zeros(cells(k).nVertices,1)];
            end
        end
        if app.importPlottingOptions.cellForcesTotal
            tempData = importedTotalForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.totalX = tempData(:,1);
            cells(k).forces.totalY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesCortical
            tempData = importedCorticalForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.corticalX = tempData(:,1);
            cells(k).forces.corticalY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesJunctions
            tempData = importedJunctionForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.junctionX = tempData(:,1);
            cells(k).forces.junctionY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesDivision
            tempData = importedDivisionForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.divisionX = tempData(:,1);
            cells(k).forces.divisionY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesMembrane
            tempData = importedMembraneForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.membraneX = tempData(:,1);
            cells(k).forces.membraneY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesContact
            tempData = importedContactForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.contactX = tempData(:,1);
            cells(k).forces.contactY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesArea
            tempData = importedAreaForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.areaX = tempData(:,1);
            cells(k).forces.areaY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesPointlike
            tempData = importedPointlikeForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.pointlikeX = tempData(:,1);
            cells(k).forces.pointlikeY = tempData(:,2);
        end
        if app.importPlottingOptions.cellForcesFocalAdhesions
            tempData = importedSubstrateForces(1:cells(k).nVertices,1+2*(k-1):2+2*(k-1));
            cells(k).forces.substrateX = tempData(:,1);
            cells(k).forces.substrateY = tempData(:,2);
        end
        if app.importPlottingOptions.focalAdhesions
            cells(k).substrate.points = importedFocalAdhesions(1:cells(k).nVertices,1+3*(k-1):3+3*(k-1));
            cells(k).substrate.connected = importedFocalAdhesionConnected(1:cells(k).nVertices,k);
        end
        if strcmp(app.SpecialplotDropDown.Value,'Show lineage')
            cells(k).lineage = nonzeros(importedLineages(:,k))'; 
        end
    elseif strcmp(option,'get_neighbors')
         if newImport
            cells(k).junctions.cells = importedJunctions(1:cells(k).nVertices,1+4*(k-1):2+4*(k-1));
        else
            cells(k).junctions.cells = [importedJunctions(1:cells(k).nVertices,1+2*(k-1)) zeros(cells(k).nVertices,1)];
        end

    elseif strcmp(option,'opto_analysis')
        if newImport
            cells(k).junctions.cells = importedJunctions(1:cells(k).nVertices,1+4*(k-1):2+4*(k-1));
            cells(k).junctions.vertices = importedJunctions(1:cells(k).nVertices,3+4*(k-1):4+4*(k-1));

            cells(k) = get_boundary_vectors(cells(k));
            cells(k) = get_boundary_lengths(cells(k));
            cells(k) = get_cell_perimeters(cells(k));
            
        else
            cells(k).junctions.cells = [importedJunctions(1:cells(k).nVertices,1+2*(k-1)) zeros(cells(k).nVertices,1)];
            cells(k).junctions.vertices = [importedJunctions(1:cells(k).nVertices,2+2*(k-1)) zeros(cells(k).nVertices,1)];
            cells(k).corticalTension = importedCorticalTensions(1,k);
            cells(k).corticalConstant = importedCorticalConstants(1,k);

            cells(k) = get_boundary_vectors(cells(k));
            cells(k) = get_boundary_lengths(cells(k));
            cells(k) = get_cell_perimeters(cells(k));
            
        end
    end
    
end

 if strcmp (option, 'post_plotting') && (app.importPlottingOptions.junctions || app.importPlottingOptions.cellStyle == 3 || app.importPlottingOptions.cellStyle == 5)
     cells = initialize_junction_data(cells);
 end
 
end