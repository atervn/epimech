function available = check_substrate_import(app)
% CHECK_SUBSTRATE_IMPORT Check that substrate is ready for import.
%   The function makes sure that everything needed for importing substrate
%   for a simulation is available in the imported simulation.
%   INPUT:
%       app: main application object
%   OUTPUT:
%       available: boolean to indicate that things are available
%   by Aapo Tervonen, 2021

% true by default
available = true;

% get the folder name
folderName = app.import.folderName;

% check if substrate coordiante data is available
if exist([folderName '/substrate/substrate_points_1.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if substrate adhesion number data is available
if exist([folderName '/substrate/substrate_adhesion_numbers_1.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if original point x-coordinates are available
if exist([folderName '/substrate_auxiliary/points_original_x.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if original point y-coordinates are available
if exist([folderName '/substrate_auxiliary/points_original_y.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if the interaction "selves" are available
if exist([folderName '/substrate_auxiliary/interaction_selves_idx.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if the substrate pairs are available
if exist([folderName '/substrate_auxiliary/interaction_pairs_idx.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if the direct interaction linear indices are available
if exist([folderName '/substrate_auxiliary/interaction_lin_idx.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if the direct interaction counter linear indices are available
if exist([folderName '/substrate_auxiliary/counter_interaction_lin_idx.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if the repulsion interaction linear indices area available
% LEGACY
if exist([folderName '/substrate_auxiliary/repulsion_lin_idx.csv']) ~= 2 %#ok<*EXIST>
    if exist([folderName '/substrate_auxiliary/boundary_repulsion_lin_idx.csv']) ~= 2 %#ok<*EXIST>
        available = false; return
    end
end

% check if the repulsion interaction vector 1 indices are available
% LEGACY
if exist([folderName '/substrate_auxiliary/repulsion_vectors1_idx.csv']) ~= 2 %#ok<*EXIST>
    if exist([folderName '/substrate_auxiliary/boundary_repulsion_vectors_idx.csv']) ~= 2 %#ok<*EXIST>
        available = false; return
    end
end

% check if the repulsion interaction vector 2 indices are available
% LEGACY
if exist([folderName '/substrate_auxiliary/repulsion_vectors2_idx.csv']) ~= 2 %#ok<*EXIST>
    if exist([folderName '/substrate_auxiliary/boundary_repulsion_vectors2_idx.csv']) ~= 2 %#ok<*EXIST>
        available = false; return
    end
end

% check if the repulsion interaction change signs indices
% LEGACY
if exist([folderName '/substrate_auxiliary/repulsion_change_signs.csv']) ~= 2 %#ok<*EXIST>
    if exist([folderName '/substrate_auxiliary/boundary_repulsion_change_signs.csv']) ~= 2 %#ok<*EXIST>
        available = false; return
    end
end

% check if the spring honeycomb multipliers are available
if exist([folderName '/substrate_auxiliary/spring_multipliers.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if the restorative spring constants are available
if exist([folderName '/substrate_auxiliary/restorative_spring_constant.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check if the repulsion spring constants are available
% LEGACY
if exist([folderName '/substrate_auxiliary/repulsion_spring_constant.csv']) ~= 2 %#ok<*EXIST>
    if exist([folderName '/substrate_auxiliary/boudary_repulsion_spring_constant.csv']) ~= 2 %#ok<*EXIST>
        available = false; return
    end
end

% check if the central spring constants are available
% LEGACY
if exist([folderName '/substrate_auxiliary/central_spring_constant.csv']) ~= 2 %#ok<*EXIST>
    if exist([folderName '/substrate_auxiliary/direct_interaction_spring_constant.csv']) ~= 2 %#ok<*EXIST>
        available = false; return
    end
end

% check if the stiffness type is available
if exist([folderName '/substrate_auxiliary/stiffness_type.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

% check that substrate parameters are available
if exist([folderName '/substrate_parameters.csv']) ~= 2 %#ok<*EXIST>
    available = false; return
end

end