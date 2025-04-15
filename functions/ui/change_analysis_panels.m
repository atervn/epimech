function change_analysis_panels(app)

switch app.plotImport(app.selectedFile).simulationType
    case 'growth'
        app.PointlikeAnalysisPanel.Visible = 'Off';
        app.DropDown2.Items(strcmp(app.DropDown2.Items,'Pointlike analysis')) = [];
        app.DropDown2.Items(strcmp(app.DropDown2.Items,'Optogenetic analysis')) = [];
        if ~any(strcmp(app.DropDown2.Items,'Geometry'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Geometry'];
        end
        if ~any(strcmp(app.DropDown2.Items,'Cell forces'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Cell forces'];
        end

        app.GeometryAnalysisPanel.Visible = 'On';
        app.CellForcesAnalysisPanel.Visible = 'Off';
        app.OptogeneticAnalysisPanel.Visible = 'Off';
        app.PointlikeAnalysisPanel.Visible = 'Off';
        
        app.DropDown2.Value = 'Geometry';
        
    case 'pointlike'
        
        app.DropDown2.Items(strcmp(app.DropDown2.Items,'Optogenetic analysis')) = [];
        if ~any(strcmp(app.DropDown2.Items,'Geometry'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Geometry'];
        end
        if ~any(strcmp(app.DropDown2.Items,'Cell forces'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Cell forces'];
        end
        if ~any(strcmp(app.DropDown2.Items,'Pointlike analysis'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Pointlike analysis'];
        end
        
        if ~(~isempty(app.DropDown2.Value) && (strcmp(app.DropDown2.Value,'Geometry') || strcmp(app.DropDown2.Value,'Cell forces') || strcmp(app.DropDown2.Value,'Pointlike analysis')))
            app.DropDown2.Value = 'Geometry';
        end
        
        switch app.DropDown2.Value
            case 'Geometry'
                app.GeometryAnalysisPanel.Visible = 'On';
                app.CellForcesAnalysisPanel.Visible = 'Off';
                app.PointlikeAnalysisPanel.Visible = 'Off';
                app.OptogeneticAnalysisPanel.Visible = 'Off';
            case 'Cell forces'
                app.GeometryAnalysisPanel.Visible = 'Off';
                app.CellForcesAnalysisPanel.Visible = 'On';
                app.PointlikeAnalysisPanel.Visible = 'Off';
                app.OptogeneticAnalysisPanel.Visible = 'Off';
            case 'Pointlike analysis'
                app.GeometryAnalysisPanel.Visible = 'Off';
                app.CellForcesAnalysisPanel.Visible = 'Off';
                app.PointlikeAnalysisPanel.Visible = 'On';
                app.OptogeneticAnalysisPanel.Visible = 'Off';
        end
       
        
    case 'opto'
        
        if isfield(app.plotImport(app.selectedFile),'optoSelectedCells') && length(app.plotImport(app.selectedFile).optoSelectedCells) == 2
            app.AnalyzejunctionlengthButton.Enable = 'On';
        else
            app.AnalyzejunctionlengthButton.Enable = 'Off';
        end
        
        if length(app.plotImport) > 1 && app.selectedFile > 1 && isfield(app.plotImport(app.selectedFile-1),'optoSelectedCells') && length(app.plotImport(app.selectedFile-1).optoSelectedCells) == 2
            app.CopypreviouscellsButton.Enable = 'On';
        else
            app.CopypreviouscellsButton.Enable = 'Off';
        end
        
        app.PointlikeAnalysisPanel.Visible = 'Off';
        app.DropDown2.Items(strcmp(app.DropDown2.Items,'Pointlike analysis')) = [];
        if ~any(strcmp(app.DropDown2.Items,'Geometry'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Geometry'];
        end
        if ~any(strcmp(app.DropDown2.Items,'Cell forces'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Cell forces'];
        end
        if ~any(strcmp(app.DropDown2.Items,'Optogenetic analysis'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Optogenetic analysis'];
        end
        
        
        if ~(~isempty(app.DropDown2.Value) && (strcmp(app.DropDown2.Value,'Geometry') || strcmp(app.DropDown2.Value,'Cell forces') || strcmp(app.DropDown2.Value,'Optogenetic analysis')))
            app.DropDown2.Value = 'Geometry';
        end
        
        switch app.DropDown2.Value
            case 'Geometry'
                app.GeometryAnalysisPanel.Visible = 'On';
                app.CellForcesAnalysisPanel.Visible = 'Off';
                app.OptogeneticAnalysisPanel.Visible = 'Off';
            case 'Cell forces'
                app.GeometryAnalysisPanel.Visible = 'Off';
                app.CellForcesAnalysisPanel.Visible = 'On';
                app.OptogeneticAnalysisPanel.Visible = 'Off';
            case 'Optogenetic analysis'
                app.GeometryAnalysisPanel.Visible = 'Off';
                app.CellForcesAnalysisPanel.Visible = 'Off';
                app.OptogeneticAnalysisPanel.Visible = 'On';
        end
        
    case 'glass'
                
        app.PointlikeAnalysisPanel.Visible = 'Off';

        app.DropDown2.Items(strcmp(app.DropDown2.Items,'Pointlike analysis')) = [];
        app.DropDown2.Items(strcmp(app.DropDown2.Items,'Optogenetic analysis')) = [];

        if ~any(strcmp(app.DropDown2.Items,'Geometry'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Geometry'];
        end
        if ~any(strcmp(app.DropDown2.Items,'Cell forces'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Cell forces'];
        end
        if ~any(strcmp(app.DropDown2.Items,'Glass analysis'))
            app.DropDown2.Items = [app.DropDown2.Items, 'Glass analysis'];
        end

        if ~(~isempty(app.DropDown2.Value) && (strcmp(app.DropDown2.Value,'Geometry') || strcmp(app.DropDown2.Value,'Cell forces') || strcmp(app.DropDown2.Value,'Glass analysis')))
            app.DropDown2.Value = 'Geometry';
        end
        
        switch app.DropDown2.Value
            case 'Geometry'
                app.GeometryAnalysisPanel.Visible = 'On';
                app.CellForcesAnalysisPanel.Visible = 'Off';
                app.OptogeneticAnalysisPanel.Visible = 'Off';
            case 'Cell forces'
                app.GeometryAnalysisPanel.Visible = 'Off';
                app.CellForcesAnalysisPanel.Visible = 'On';
                app.OptogeneticAnalysisPanel.Visible = 'Off';
            case 'Glass analysis'
                app.GeometryAnalysisPanel.Visible = 'Off';
                app.CellForcesAnalysisPanel.Visible = 'Off';
                app.GlassAnalysisPanel.Visible = 'On';
        end
        
        
end

end