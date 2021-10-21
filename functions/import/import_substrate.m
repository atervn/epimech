function d = import_substrate(app,d)
% IMPORT_SUBSTRATE Import substrate for simulation or plotting
%   The function imports the substrate data from an unzipped past
%   simulation for the initial point of a new simulation or for post
%   plotting. For plotting, the substrate forces are also imported if
%   needed.
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% check if simulation or post plotting
switch app.appTask
    
    % simulation
    case 'simulate'
        
        % get the folder name and the current time point index
        folderName = app.import.folderName;
        currentTimePoint = num2str(app.import.currentTimePoint);
        
        % import substrate point coordinates and assign the values to the
        % coordinate vectors
        importedPoints = csvread([folderName '/substrate/substrate_points_' currentTimePoint, '.csv']);
        d.sub.pointsX = importedPoints(:,1);
        d.sub.pointsY = importedPoints(:,2);
        
        % get the number of substrate points
        d.sub.nPoints = length(d.sub.pointsX);
        
        % get the number of adhesions for the substrate points
        d.sub.adhesionNumbers = csvread([folderName '/substrate/substrate_adhesion_numbers_' currentTimePoint, '.csv']);
        
        % get the initial substrate point coordinates
        d.sub.pointsOriginalX = csvread([folderName '/substrate_auxiliary/points_original_x.csv']);
        d.sub.pointsOriginalY = csvread([folderName '/substrate_auxiliary/points_original_y.csv']);
        
        % get the interaction "selves" and pairs for each substrate
        % interactions
        d.sub.interactionSelvesIdx = csvread([folderName '/substrate_auxiliary/interaction_selves_idx.csv']);
        d.sub.interactionPairsIdx = csvread([folderName '/substrate_auxiliary/interaction_pairs_idx.csv']);
        
        % get the linear indices for the unique and counter interactions in
        % the central force matrix
        d.sub.interactionLinIdx = csvread([folderName '/substrate_auxiliary/interaction_lin_idx.csv']);
        d.sub.counterInteractionLinIdx = csvread([folderName '/substrate_auxiliary/counter_interaction_lin_idx.csv']);
        
        % get the repulsion vectors (1 and 2), the linear indices in the
        % repulsion force matrix and the change signs vector
        % LEGACY (name changes)
        try
            d.sub.repulsionLinIdx = csvread([folderName '/substrate_auxiliary/repulsion_lin_idx.csv']);
            d.sub.repulsionVectors1Idx = csvread([folderName '/substrate_auxiliary/repulsion_vectors1_idx.csv']);
            d.sub.repulsionVectors2Idx = csvread([folderName '/substrate_auxiliary/repulsion_vectors2_idx.csv']);
            d.sub.repulsionChangeSigns = csvread([folderName '/substrate_auxiliary/repulsion_change_signs.csv']);
        catch
            d.sub.repulsionLinIdx = csvread([folderName '/substrate_auxiliary/boundary_repulsion_lin_idx.csv']);
            d.sub.repulsionVectors1Idx = csvread([folderName '/substrate_auxiliary/boundary_repulsion_vectors_idx.csv']);
            d.sub.repulsionVectors2Idx = csvread([folderName '/substrate_auxiliary/boundary_repulsion_vectors2_idx.csv']);
            d.sub.repulsionChangeSigns = csvread([folderName '/substrate_auxiliary/boundary_repulsion_change_signs.csv']);
        end
        
        % import the honeycomb spring multipliers
        d.sub.springMultipliers = csvread([folderName '/substrate_auxiliary/spring_multipliers.csv']);
        
        
        % get the central interaction spring constants
        % LEGACY (name change)
        try
            d.sub.centralSpringConstants = csvread([folderName '/substrate_auxiliary/central_spring_constant.csv']);
        catch
            d.sub.centralSpringConstants = csvread([folderName '/substrate_auxiliary/direct_interaction_spring_constant.csv']);
        end
        
        % get the repulsion interaction spring constants
        % LEGACY (name change)
        try
            d.sub.repulsionSpringConstants = csvread([folderName '/substrate_auxiliary/repulsion_spring_constant.csv']);
        catch
            d.sub.repulsionSpringConstants = csvread([folderName '/substrate_auxiliary/boudary_repulsion_spring_constant.csv']);
        end
        
        % get the restorative spring contants
        d.sub.restorativeSpringConstants = csvread([folderName '/substrate_auxiliary/restorative_spring_constant.csv']);
        
        % get the edge points
        d.sub.edgePoints = logical(csvread([folderName '/substrate_auxiliary/edge_points.csv']));
        
        % create the empty force matrix
        d.sub.emptyMatrix = zeros(6,d.sub.nPoints);
        
    % post plotting
    case 'plotAndAnalyze'
        
        % if the substrate style is not hidden or if any of the substrate
        % forces is plotted
        if d.pl.substrateStyle ~= 0 || any([d.pl.substrateForcesTotal d.pl.substrateForcesCentral d.pl.substrateForcesRestoration d.pl.substrateForcesRepulsion d.pl.substrateForcesFocalAdhesions])
            
            % get the folder name
            folderName = app.plotImport(app.selectedFile).folderName;
            
            % import substrate point coordinates and assign the values to the
            % coordinate vectors
            importedPoints = csvread([folderName '/substrate/substrate_points_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
            d.sub.pointsX = importedPoints(:,1);
            d.sub.pointsY = importedPoints(:,2);
            
            if ~strcmp(app.plotImport(app.selectedFile).simulationType,'stretch')
                
                % get the initial substrate point coordinates
                d.sub.pointsOriginalX = csvread([folderName '/substrate_auxiliary/points_original_x.csv']);
                d.sub.pointsOriginalY = csvread([folderName '/substrate_auxiliary/points_original_y.csv']);
                
                % get the interaction "selves" and pairs for each substrate
                % interactions
                d.sub.interactionSelvesIdx = csvread([folderName '/substrate_auxiliary/interaction_selves_idx.csv']);
                d.sub.interactionPairsIdx = csvread([folderName '/substrate_auxiliary/interaction_pairs_idx.csv']);
                
                % import forces to be plotted
                d = import_substrate_forces(app, d, folderName);
            end
        end
            
end

end

function d = import_substrate_forces(app, d, folderName)
% IMPORT_SUBSTRATE_FORCES Import substrate forces for plotting and analysis
%   The functions imports the required substrate forces for post plotting
%   and analysis.
%   INPUT:
%       d: main simulation data structure
%       folderName: import folder name
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if central forces are plotted
if d.pl.substrateForcesCentral
    
    % import central forces
    % LEGACY (name change)
    try
        importedForces = csvread([folderName '/substrate_forces/central/central_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
    catch
        importedForces = csvread([folderName '/substrate_forces/direct/direct_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
    end
    
    % assign the force components
    d.sub.forces.centralX = importedForces(:,1);
    d.sub.forces.centralY = importedForces(:,2);
end

% if repulsion forces are plotted
if d.pl.substrateForcesRepulsion
    
    % import central forces
    importedForces = csvread([folderName '/substrate_forces/repulsion/repulsion_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
    
    % assign the force components
    d.sub.forces.repulsionX = importedForces(:,1);
    d.sub.forces.repulsionY = importedForces(:,2);
end

% if restorative forces are plotted
if d.pl.substrateForcesRestoration
    
    % import central forces
    importedForces = csvread([folderName '/substrate_forces/restoration/restoration_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
    
    % assign the force components
    d.sub.forces.restorativeX = importedForces(:,1);
    d.sub.forces.restorativeY = importedForces(:,2);
end

% if focal adhesion forces are plotted
if d.pl.substrateForcesFocalAdhesions
    
    % import central forces
    importedForces = csvread([folderName '/substrate_forces/focal_adhesion/focal_adhesion_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
    
    % assign the force components
    d.sub.forces.focalAdhesionsX = importedForces(:,1);
    d.sub.forces.focalAdhesionsY = importedForces(:,2);
end

% if total forces are plotted
if d.pl.substrateForcesTotal
    
    % import central forces
    importedForces = csvread([folderName '/substrate_forces/total/total_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
    
    % assign the force components
    d.sub.forces.totalX = importedForces(:,1);
    d.sub.forces.totalY = importedForces(:,2);
end

end