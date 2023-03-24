function set_panel_visibilities(app)

switch app.appTask
    case 'simulate'
        
        switch app.modelCase
            case 'new'
                set_object_properties_function(app,{'InitialstatePanel_2'},'Visible',{'Off'})
                set_object_properties_function(app,{'ParametersPanel','ComponentsettingsPanel','PlottingoptionsPanel','ExportoptionsPanel', 'InitialstatePanel', 'SimulationsettingsPanel','SimulateButton'},'Visible',{'On'})
            case 'import'
                set_object_properties_function(app,{'InitialstatePanel'},'Visible',{'Off'})
                set_object_properties_function(app,{'ParametersPanel','ComponentsettingsPanel','PlottingoptionsPanel','ExportoptionsPanel','InitialstatePanel_2','SimulationsettingsPanel','SimulateButton'},'Visible',{'On'})
        end
        
        set_object_properties_function(app,{'ParameterstipsImage','ComponentstipsImage','InitialstatetipsImage','PlottingtipsImage_1','ExportoptionsImage','SimulationsettingstipsImage'},'Visible',{'On'})
        
        change_panel_tooltips(app,'all')
        
    case 'plotAndAnalyze'
        set_object_properties_function(app,{'ClearButton','PlotPanel','PlottingoptionsPanel_2','AnimationPanel','SpecialplottingoptionsPanel','AnalysisPanel','LoadedfilesDropDown','ParametersPanel_2'},'Visible',{'On'});
        
        set_object_properties_function(app,{'AnalysistipsImage','SpecialplottingtipsImage','PostparameterstipsImage','PostplottingtipsImage','PostplottingoptionstipsImage','AnimationtipsImage'},'Visible',{'On'})
           
end