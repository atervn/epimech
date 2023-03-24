function change_panel_tooltips(app,changeCase)

if strcmp('all',changeCase)
    app.ParameterstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/parameters_tooltip.txt']);
    
    app.PlottingtipsImage_1.Tooltip = fileread([app.defaultPath 'settings/tooltips/plotting_options_simulation_tooltip.txt']);
    
    app.ExportoptionsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/export_options_tooltip.txt']);
    
    app.SimulationsettingstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/simulation_settings_tooltip.txt']);
    
    app.PostplottingoptionstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/plotting_options_analysis_tooltip.txt']);
    
    app.PostplottingtipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/post_plotting_tooltip.txt']);
    
    app.AnimationtipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/post_animation_tooltip.txt']);
    
    app.PostparameterstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/post_parameters_tooltip.txt']);
    
    if strcmp(app.InitialstatePanel.Visible, 'on')                
        app.InitialstatetipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/initial_state_new_tooltip.txt']);
    elseif strcmp(app.InitialstatePanel_2.Visible, 'on')
        app.InitialstatetipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/initial_state_import_tooltip.txt']);
    end
end

if strcmp('components_panel',changeCase) || strcmp('all',changeCase)
    if strcmp(app.DivisionsettingsPanel.Visible, 'on')                
        app.ComponentstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/division_settings_tooltip.txt']);
    elseif strcmp(app.SubstrateSizePanel.Visible, 'on')
        app.ComponentstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/substrate_size_tooltip.txt']);
    elseif strcmp(app.PointlikesettingsPanel.Visible, 'on')
        app.ComponentstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/pointlike_settings_tooltip.txt']);
    elseif strcmp(app.CellsizesettingsPanel.Visible, 'on')
        app.ComponentstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/cell_size_tooltip.txt']);
    elseif strcmp(app.SubstrateStiffnessPanel.Visible, 'on')
        app.ComponentstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/substrate_stiffness_tooltip.txt']);
    elseif strcmp(app.FocalAdhesionsPanel.Visible, 'on')
        app.ComponentstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/focal_adhesions_tooltip.txt']);
    elseif strcmp(app.StretchSettingsPanel.Visible, 'on')
        app.ComponentstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/stretch_settings_tooltip.txt']);
    elseif strcmp(app.OptogeneticsPanel.Visible, 'on')
        app.ComponentstipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/optogenetic_activation_tooltip.txt']);
    end
end

if strcmp('analysis_panel',changeCase) || strcmp('all',changeCase)
    if strcmp(app.GeometryAnalysisPanel.Visible, 'on')                
        app.AnalysistipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/geometry_analysis_tooltip.txt']);
    elseif strcmp(app.CellForcesAnalysisPanel.Visible, 'on')
        app.AnalysistipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/cell_forces_analysis_tooltip.txt']);
    elseif strcmp(app.PointlikeAnalysisPanel.Visible, 'on')
        app.AnalysistipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/pointlike_analysis_tooltip.txt']);
    elseif strcmp(app.OptogeneticAnalysisPanel.Visible, 'on')
        app.AnalysistipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/optogenetic_analysis_tooltip.txt']);
    end
end

if strcmp('special_plotting_panel',changeCase) || strcmp('all',changeCase)
    if strcmp(app.ShowcelllineagePanel.Visible, 'on')                
        app.SpecialplottingtipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/show_lineage_tooltip.txt']);
    elseif strcmp(app.HighlightcellsPanel.Visible, 'on')
        app.SpecialplottingtipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/highlight_cells_tooltip.txt']);
    elseif strcmp(app.ForcemagnitudeplottingPanel.Visible, 'on')
        app.SpecialplottingtipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/force_magnitude_tooltip.txt']);
    elseif strcmp(app.CellshapedescriptorsPanel.Visible, 'on')
        app.SpecialplottingtipsImage.Tooltip = fileread([app.defaultPath 'settings/tooltips/shape_descriptors_tooltip.txt']);
    else
        app.SpecialplottingtipsImage.Tooltip = '';
    end
end

end
