function d = setup_simulation(app)

if strcmp(app.simulationType,'growth') && app.UniformdivisiontimesCheckBox.Value == 1
    rng(2);
else
    rng shuffle
end
    
d = initialize_d_structure;

startingTime = clock;

d.spar = scale_parameters(app);
d.simset = define_simulation_settings(app,d.spar);

%% Cells

switch app.modelCase
    case 'new'
        d.cells = initialize_cells_struct;
        switch app.InitialstateButtongroup.SelectedObject.Text
            case 'Single cell'
                d = single_cell_initialization(d,[0;0]);
            case 'Place multiple cells'
                for i = 1:size(app.cellCenters,1)
                    d = single_cell_initialization(d,app.cellCenters(i,:));
                end
        end
        d.cells = assign_cortical_tensions(app, d.cells,d.spar);
    case 'loaded'
        
        d.spar.normArea = app.import.scaledParameters.normArea*app.import.scaledParameters.scalingLength^2/app.systemParameters.scalingLength;
        d.spar.membraneLength = app.import.scaledParameters.membraneLength*app.import.scaledParameters.scalingLength/app.systemParameters.scalingLength;
  
        d.cells = import_cells(app,'simulation');
        d.cells = remove_cells_gui(app, d.cells,'simulation');
        d.cells = assign_cortical_tensions(app, d.cells, d.spar);
        d.cells = initialize_junction_data(d.cells);
        
        if d.simset.simulationType == 1
            d.cells = set_division_times(d.cells,d.simset,d.spar,length(d.cells));
        end
        
        if any(d.simset.simulationType == [2 5])
            for k = 1:length(d.cells)
                if d.cells(k).division.state ~= 0
                    d.cells(k).division.state = 0;
                    d.cells(k).normArea = d.cells(k).area*1.1;
                end
            end
        end
    
end
if any(d.simset.simulationType == [2,3,5])
    d = get_edge_vertices(d);
end

%% Substrate

d.sub = initialize_substrate_structure;

if any(d.simset.simulationType == [2,3,5])
    
    % create or import the substrate
    if strcmp(app.modelCase,'new') ||...
            (strcmp(app.modelCase,'loaded') && strcmp(app.import.simulationType,'growth')) ||...
            (strcmp(app.modelCase,'loaded') && (strcmp(app.import.simulationType,'pointlike')) && ~app.UseimportedsubstratedataCheckBox.Value) ||...
            (strcmp(app.modelCase,'loaded') && (strcmp(app.import.simulationType,'opto')) && ~app.UseimportedsubstratedataCheckBox.Value)
        
        % define the required substrate size, if fitted
        if strcmp(app.SubstrateTypeButtonGroup.SelectedObject.Text,'Fitted') || ...
                (strcmp(app.SubstrateTypeButtonGroup.SelectedObject.Text,'Square') && ~app.ManualsizeCheckBox.Value)
            maxPointX = zeros(1,length(d.cells));
            minPointX = maxPointX;
            maxPointY = maxPointX;
            minPointY = maxPointX;
            for k = 1:length(d.cells)
                maxPointX(k) = max(d.cells(k).verticesX);
                minPointX(k) = min(d.cells(k).verticesX);
                maxPointY(k) = max(d.cells(k).verticesY);
                minPointY(k) = min(d.cells(k).verticesY);
            end
            
            maxSize = max(max(abs([maxPointX; minPointX; maxPointY; minPointY])));
            
            d.spar.substrateSize = maxSize*2 + d.spar.rCell;
        else
            for k = 1:length(d.cells)
                if any(d.cells(k).verticesX > d.spar.substrateSize/2) || ...
                        any(d.cells(k).verticesX < -d.spar.substrateSize/2) || ...
                        any(d.cells(k).verticesY > d.spar.substrateSize/2) || ...
                        any(d.cells(k).verticesY < -d.spar.substrateSize/2)
                    d = 0;
                    return;
                end
            end
        end
        
        % define substrate
        d = form_substrate(d,app);
        if ~isstruct(d); return; end
        
        expansionMultiplier = 1.5;
        
        while 1
            % remove extra points if fitted
            if strcmp(app.SubstrateTypeButtonGroup.SelectedObject.Text,'Fitted')
                d = remove_substrate_points(d,app,expansionMultiplier);
                if ~isstruct(d); return; end
            end
            if any(d.simset.simulationType == [2,5])
                d = get_substrate_spring_constants(d,app);
                d = get_substrate_edge_points(d);
            end
            
            
            % define focal adhesions
            progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Linking focal adhesions','Indeterminate','on');
            [d, ok] = form_focal_adhesions(d,app);
            if ~ok
                expansionMultiplier = expansionMultiplier*1.1;
            else
                break;
            end
            
        end
        close(progressdlg);
    elseif strcmp(app.modelCase,'loaded') && app.UseimportedsubstratedataCheckBox.Value
        
        d = import_substrate(app,d);
        
    end
    
end

%% opto

if d.simset.simulationType == 5
    d.simset.opto.times = [app.optoActivation(:,1) ; 1e12]./d.spar.scalingTime;
    d.simset.opto.levels = [app.optoActivation(:,2); app.optoActivation(end,2)].*d.spar.fullActivationConstant;
    d.simset.opto.shapes = app.optoShapes;
    d.simset.opto.cells = app.optoVertices.cells;
    d.simset.opto.vertices = app.optoVertices.vertices;
    d.simset.opto.currentTime = 1;
end


%% Pointlike stuff

d = setup_pointlike_settings(d,app);

%% Frame stuff

d = setup_frame(d);

%% Plotting

d = set_plotting_options(app,'simulate',d);

%% Export

d.ex = setup_exporting(app,d,startingTime);

disable_enable_all_function(app,'Off')

end
