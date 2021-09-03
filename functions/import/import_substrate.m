function d = import_substrate(app,d)

switch app.appTask
    case 'simulate'
        folderName = app.import.folderName;
        currentTimePoint = num2str(app.import.currentTimePoint);
        
        importedPoints = csvread([folderName '/substrate/substrate_points_' currentTimePoint, '.csv']);
        d.sub.pointsX = importedPoints(:,1);
        d.sub.pointsY = importedPoints(:,2);
        d.sub.adhesionNumbers = csvread([folderName '/substrate/substrate_adhesion_numbers_' currentTimePoint, '.csv']);  
        d.sub.nPoints = length(d.sub.pointsX);
        
        d.sub.pointsOriginalX = csvread([folderName '/substrate_auxiliary/points_original_x.csv']);
        d.sub.pointsOriginalY = csvread([folderName '/substrate_auxiliary/points_original_y.csv']);
        d.sub.interactionSelvesIdx = csvread([folderName '/substrate_auxiliary/interaction_selves_idx.csv']);
        d.sub.interactionPairsIdx = csvread([folderName '/substrate_auxiliary/interaction_pairs_idx.csv']);
        d.sub.interactionLinIdx = csvread([folderName '/substrate_auxiliary/interaction_lin_idx.csv']);
        d.sub.counterInteractionLinIdx = csvread([folderName '/substrate_auxiliary/counter_interaction_lin_idx.csv']);
        d.sub.boundaryRepulsionLinIdx = csvread([folderName '/substrate_auxiliary/boundary_repulsion_lin_idx.csv']);
        d.sub.boundaryRepulsionVectorsIdx = csvread([folderName '/substrate_auxiliary/boundary_repulsion_vectors_idx.csv']);
        d.sub.boundaryRepulsionVectors2Idx = csvread([folderName '/substrate_auxiliary/boundary_repulsion_vectors2_idx.csv']);
        d.sub.boundaryRepulsionChangeSigns = csvread([folderName '/substrate_auxiliary/boundary_repulsion_change_signs.csv']);
        d.sub.springMultipliers = csvread([folderName '/substrate_auxiliary/spring_multipliers.csv']);
        d.sub.emptyMatrix = zeros(6,d.sub.nPoints);
        d.sub.edgePoints = logical(csvread([folderName '/substrate_auxiliary/edge_points.csv']));
        d.sub.restorativeSpringConstants = csvread([folderName '/substrate_auxiliary/restorative_spring_constant.csv']);
        d.sub.directInteractionSpringConstants = csvread([folderName '/substrate_auxiliary/direct_interaction_spring_constant.csv']);
        d.sub.boundaryRepulsionSpringConstants = csvread([folderName '/substrate_auxiliary/boudary_repulsion_spring_constant.csv']);
        
        
    case 'plotAndAnalyze'
        
        subForcesPlot = d.pl.substrateForcesTotal + d.pl.substrateForcesDirect + d.pl.substrateForcesRestoration + d.pl.substrateForcesRepulsion + d.pl.substrateForcesFocalAdhesions;
        
        if d.pl.substrateStyle ~= 0 || subForcesPlot > 0
            
            folderName = app.plotImport(app.selectedFile).folderName;
            
            importedPoints = csvread([folderName '/substrate/substrate_points_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
            d.sub.pointsX = importedPoints(:,1);
            d.sub.pointsY = importedPoints(:,2);
            
            d.sub.pointsOriginalX = csvread([folderName '/substrate_auxiliary/points_original_x.csv']);
            d.sub.pointsOriginalY = csvread([folderName '/substrate_auxiliary/points_original_y.csv']);
            d.sub.interactionSelvesIdx = csvread([folderName '/substrate_auxiliary/interaction_selves_idx.csv']);
            d.sub.interactionPairsIdx = csvread([folderName '/substrate_auxiliary/interaction_pairs_idx.csv']);
            
            if d.pl.substrateForcesDirect
                importedForces = csvread([folderName '/substrate_forces/direct/direct_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
                d.sub.forces.directX = importedForces(:,1);
                d.sub.forces.directY = importedForces(:,2);
            end
            if d.pl.substrateForcesRepulsion
                importedForces = csvread([folderName '/substrate_forces/repulsion/repulsion_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
                d.sub.forces.boundaryRepulsionX = importedForces(:,1);
                d.sub.forces.boundaryRepulsionY = importedForces(:,2);
            end
            if d.pl.substrateForcesRestoration
                importedForces = csvread([folderName '/substrate_forces/restoration/restoration_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
                d.sub.forces.restorativeX = importedForces(:,1);
                d.sub.forces.restorativeY = importedForces(:,2);
            end
            if d.pl.substrateForcesFocalAdhesions
                importedForces = csvread([folderName '/substrate_forces/focal_adhesion/focal_adhesion_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
                d.sub.forces.focalAdhesionsX = importedForces(:,1);
                d.sub.forces.focalAdhesionsY = importedForces(:,2);
            end
            if d.pl.substrateForcesTotal
                importedForces = csvread([folderName '/substrate_forces/total/total_' num2str(app.plotImport(app.selectedFile).currentTimePoint), '.csv']);
                d.sub.forces.totalX = importedForces(:,1);
                d.sub.forces.totalY = importedForces(:,2);
            end
            
        end
end