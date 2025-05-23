function set_component_settings_panel(app,varargin)

if numel(varargin) > 0 && strcmp(varargin{1},'reset')
    switch app.appTask
        case 'simulate'
            app.DivisionsettingsPanel.Visible = 'Off';
            app.SubstrateSizePanel.Visible = 'Off';
            app.PointlikesettingsPanel.Visible = 'Off';
            app.StretchSettingsPanel.Visible = 'Off';
            app.CellsizesettingsPanel.Visible = 'Off';
            app.SubstrateStiffnessPanel.Visible = 'Off';
            app.FocalAdhesionsPanel.Visible = 'Off';
            app.ComponentsettingsDropdown.Items = {};
            
            set_object_properties_function(app,{'ParameterstipsImage','ComponentstipsImage','InitialstatetipsImage','PlottingtipsImage_1','ExportoptionsImage','SimulationsettingstipsImage'},'Visible',{'Off'})
            
        case 'plotAndAnalyze'

            app.SpecialplotDropDown.Value = {'Normal'};
            set_object_properties_function(app,{'HighlightcellsPanel', 'ShowcelllineagePanel','ForcemagnitudeplottingPanel','CellshapedescriptorsPanel'},'Visible',{'Off'})
            set_object_properties_function(app,{'BrowsetimepointsButton','PlottingstepEditField_2',...
                'PlottingstepEditField_2','xdtLabel_3','CellstyleDropDown_2','CellstyleDropDown_2Label','PlottingoptionsButton_2','AutomaticsizeCheckBox_2','SavevideoCheckBox_2','AnimateButton'},'Enable',{'On'})
            if app.AutomaticsizeCheckBox_2.Value
                set_object_properties_function(app,{'WindowsizeSlider_2','WindowsizeSlider_2Label','WindowsizeEditField_2','WindowsizeText_2'},'Enable',{'Off'})
            end
            if app.SavevideoCheckBox_2.Value
                set_object_properties_function(app,{'CompressvideoCheckBox_2','VideonameEditField','VideonameEditFieldLabel' ,'Reload2Button'},'Enable',{'On'})
            end
            app.GeometryAnalysisPanel.Visible = 'Off';
            app.CellForcesAnalysisPanel.Visible = 'Off';
            app.PointlikeAnalysisPanel.Visible = 'Off';
            app.OptogeneticAnalysisPanel.Visible = 'Off';
            app.ParametersPanel_2.Visible = 'Off';
            app.GlassAnalysisPanel.Visible = 'Off';
            
            set_object_properties_function(app,{'AnalysistipsImage','SpecialplottingtipsImage','PostparameterstipsImage','PostplottingtipsImage','PostplottingoptionstipsImage','AnimationtipsImage'},'Visible',{'Off'})
            
            
    end
else
    switch app.appTask
        case 'simulate'
            switch app.SimulationtypeDropDown.Value
                case 'Epithelial growth'
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Substrate size')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Substrate stiffness')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Pointlike micromanipulation')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Lateral compression and stretching')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Focal adhesions')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Optogenetics')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Edge compression')) = [];
                    
                    switch app.modelCase
                        case 'new'
                            app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, {'Division','Cell size'}];
                        case 'import'
                            app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, {'Division'}];
                    end
                    
                    app.ComponentsettingsDropdown.Value = 'Division';
                    app.DivisionsettingsPanel.Visible = 'On';
                    app.CellsizesettingsPanel.Visible = 'Off';
                    app.SubstrateSizePanel.Visible = 'Off';
                    app.SubstrateStiffnessPanel.Visible = 'Off';
                    app.FocalAdhesionsPanel.Visible = 'Off';
                    app.PointlikesettingsPanel.Visible = 'Off';
                    app.StretchSettingsPanel.Visible = 'Off';
                    app.OptogeneticsPanel.Visible = 'Off';
                    app.GlassActivationPanel.Visible = 'Off';

                    
                case 'Pointlike micromanipulation'
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Division')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Cell size')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Lateral compression and stretching')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Edge compression')) = [];
                    
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Substrate size'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Substrate size'];
                    end
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Substrate stiffness'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Substrate stiffness'];
                    end
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Focal adhesions'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Focal adhesions'];
                    end
                    
                    app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Pointlike micromanipulation'];
                    app.ComponentsettingsDropdown.Value = 'Pointlike micromanipulation';
                    app.CellsizesettingsPanel.Visible = 'Off';
                    app.DivisionsettingsPanel.Visible = 'Off';
                    app.SubstrateSizePanel.Visible = 'Off';
                    app.SubstrateStiffnessPanel.Visible = 'Off';
                    app.FocalAdhesionsPanel.Visible = 'Off';
                    app.PointlikesettingsPanel.Visible = 'On';
                    app.StretchSettingsPanel.Visible = 'Off';
                    app.OptogeneticsPanel.Visible = 'Off';
                    app.GlassActivationPanel.Visible = 'Off';
                case 'Lateral compression and stretching'
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Division')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Pointlike micromanipulation')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Substrate stiffness')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Pointlike micromanipulation')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Edge compression')) = [];
                    
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Substrate size'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Substrate size'];
                    end
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Focal adhesions'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Focal adhesions'];
                    end
                    app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Lateral compression and stretching'];
                    app.ComponentsettingsDropdown.Value = 'Lateral compression and stretching';
                    app.CellsizesettingsPanel.Visible = 'Off';
                    app.DivisionsettingsPanel.Visible = 'Off';
                    app.SubstrateSizePanel.Visible = 'Off';
                    app.SubstrateStiffnessPanel.Visible = 'Off';
                    app.FocalAdhesionsPanel.Visible = 'Off';
                    app.PointlikesettingsPanel.Visible = 'Off';
                    app.StretchSettingsPanel.Visible = 'On';
                    app.OptogeneticsPanel.Visible = 'Off';
                    app.GlassActivationPanel.Visible = 'Off';
                case 'Edge compression'
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Substrate size')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Substrate stiffness')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Pointlike micromanipulation')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Lateral compression and stretching')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Division')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Focal adhesions')) = [];

                    app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, {'Edge compression'}];
                    
                    app.ComponentsettingsDropdown.Value = 'Edge compression';
                    app.DivisionsettingsPanel.Visible = 'Off';
                    app.CellsizesettingsPanel.Visible = 'Off';
                    app.SubstrateSizePanel.Visible = 'Off';
                    app.FocalAdhesionsPanel.Visible = 'Off';
                    app.PointlikesettingsPanel.Visible = 'Off';
                    app.StretchSettingsPanel.Visible = 'Off';
                    app.OptogeneticsPanel.Visible = 'Off';
                    app.GlassActivationPanel.Visible = 'Off';
                case 'Optogenetic activation'
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Division')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Cell size')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Lateral compression and stretching')) = [];
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Substrate size'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Substrate size'];
                    end
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Substrate stiffness'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Substrate stiffness'];
                    end
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Focal adhesions'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Focal adhesions'];
                    end
                    app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Optogenetics'];
                    app.ComponentsettingsDropdown.Value = 'Optogenetics';
                    app.CellsizesettingsPanel.Visible = 'Off';
                    app.DivisionsettingsPanel.Visible = 'Off';
                    app.SubstrateSizePanel.Visible = 'Off';
                    app.SubstrateStiffnessPanel.Visible = 'Off';
                    app.FocalAdhesionsPanel.Visible = 'Off';
                    app.PointlikesettingsPanel.Visible = 'Off';
                    app.StretchSettingsPanel.Visible = 'Off';
                    app.OptogeneticsPanel.Visible = 'On';
                    app.GlassActivationPanel.Visible = 'Off';
                case 'Glass activation'
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Division')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Cell size')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Lateral compression and stretching')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Edge compression')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Pointlike micromanipulation')) = [];
                    app.ComponentsettingsDropdown.Items(strcmp(app.ComponentsettingsDropdown.Items,'Optogenetics')) = [];
                    
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Substrate size'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Substrate size'];
                    end
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Substrate stiffness'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Substrate stiffness'];
                    end
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Focal adhesions'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Focal adhesions'];
                    end
                    if ~any(strcmp(app.ComponentsettingsDropdown.Items,'Glass activation'))
                        app.ComponentsettingsDropdown.Items = [app.ComponentsettingsDropdown.Items, 'Glass activation'];
                    end
                    
                    app.ComponentsettingsDropdown.Value = 'Substrate stiffness';
                    app.CellsizesettingsPanel.Visible = 'Off';
                    app.DivisionsettingsPanel.Visible = 'Off';
                    app.SubstrateSizePanel.Visible = 'Off';
                    app.SubstrateStiffnessPanel.Visible = 'On';
                    app.FocalAdhesionsPanel.Visible = 'Off';
                    app.PointlikesettingsPanel.Visible = 'Off';
                    app.StretchSettingsPanel.Visible = 'Off';
                    app.OptogeneticsPanel.Visible = 'Off';
                    app.GlassActivationPanel.Visible = 'Off';
            end
            
            change_panel_tooltips(app,'all')
            
        case 'plotAndAnalyze'
            change_analysis_panels(app);
            
            change_panel_tooltips(app,'all')
    end
end