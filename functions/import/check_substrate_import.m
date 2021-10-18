function available = check_substrate_import(app)

        available = true;

        folderName = app.import.folderName;

        if exist([folderName '/substrate/substrate_points_1.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate/substrate_adhesion_numbers_1.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate_auxiliary/points_original_x.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate_auxiliary/points_original_y.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate_auxiliary/interaction_selves_idx.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate_auxiliary/interaction_pairs_idx.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate_auxiliary/interaction_lin_idx.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate_auxiliary/counter_interaction_lin_idx.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        % LEGACY
        if exist([folderName '/substrate_auxiliary/repulsion_lin_idx.csv']) ~= 2 %#ok<*EXIST>
            if exist([folderName '/substrate_auxiliary/boundary_repulsion_lin_idx.csv']) ~= 2 %#ok<*EXIST>
                available = false;
                return
            end
        end
        % LEGACY
        if exist([folderName '/substrate_auxiliary/repulsion_vectors1_idx.csv']) ~= 2 %#ok<*EXIST>
            if exist([folderName '/substrate_auxiliary/boundary_repulsion_vectors_idx.csv']) ~= 2 %#ok<*EXIST>
                available = false;
                return
            end
        end
        % LEGACY
        if exist([folderName '/substrate_auxiliary/repulsion_vectors2_idx.csv']) ~= 2 %#ok<*EXIST>
            if exist([folderName '/substrate_auxiliary/boundary_repulsion_vectors2_idx.csv']) ~= 2 %#ok<*EXIST>
                available = false;
                return
            end
        end
        % LEGACY
        if exist([folderName '/substrate_auxiliary/repulsion_change_signs.csv']) ~= 2 %#ok<*EXIST>
            if exist([folderName '/substrate_auxiliary/boundary_repulsion_change_signs.csv']) ~= 2 %#ok<*EXIST>
                available = false;
                return
            end
        end
        if exist([folderName '/substrate_auxiliary/spring_multipliers.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate_auxiliary/restorative_spring_constant.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        % LEGACY
        if exist([folderName '/substrate_auxiliary/repulsion_spring_constant.csv']) ~= 2 %#ok<*EXIST>
            if exist([folderName '/substrate_auxiliary/boudary_repulsion_spring_constant.csv']) ~= 2 %#ok<*EXIST>
                available = false;
                return
            end
        end
        % LEGACY
        if exist([folderName '/substrate_auxiliary/central_spring_constant.csv']) ~= 2 %#ok<*EXIST>
            if exist([folderName '/substrate_auxiliary/direct_interaction_spring_constant.csv']) ~= 2 %#ok<*EXIST>
                available = false;
                return
            end
        end
        if exist([folderName '/substrate_auxiliary/stiffness_type.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
        if exist([folderName '/substrate_parameters.csv']) ~= 2 %#ok<*EXIST>
            available = false;
            return
        end
end