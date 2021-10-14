function d = setup_substrate(app,d)
% SETUP_SUBSTRATE Setup the substrate for the simulation
%   The function created the substrate and defines the focal adhesions for
%   the simulation or imports the substrate data if needed.
%   INPUT:
%       app: main application structure
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if the simulation requires a substrate
if any(d.simset.simulationType == [2,3,5])
    
    % if new substrate is created
    if strcmp(app.modelCase,'new') ||...
            (strcmp(app.modelCase,'import') && strcmp(app.import.simulationType,'growth')) ||...
            (strcmp(app.modelCase,'import') && (strcmp(app.import.simulationType,'pointlike')) && ~app.UseimportedsubstratedataCheckBox.Value) ||...
            (strcmp(app.modelCase,'import') && (strcmp(app.import.simulationType,'opto')) && ~app.UseimportedsubstratedataCheckBox.Value)
        
        % find the square size that fits the epithelium for fitted or
        % square with automatic size
        if strcmp(app.SubstrateTypeButtonGroup.SelectedObject.Text,'Fitted') || ...
                (strcmp(app.SubstrateTypeButtonGroup.SelectedObject.Text,'Square') && ~app.ManualsizeCheckBox.Value)
            
            % find the square size that fits the epithelium
            maxSize = get_maximum_epithelium_size(d);
            
            % get the substrate size (make a bit larger)
            substrateSize = maxSize*2 + d.spar.rCell;
            
        % otherwise
        else
            
            % get the manual substrate size and scale it
            substrateSize = app.SubstratesizeEditField.Value*1e-6/d.spar.scalingLength;
            
            % go through the cells to make sure all cell vertices are on
            % the substrate
            for k = 1:length(d.cells)
                
                % if any cell vertex is outside the given substrate area,
                % set d to 0 and return
                if any(d.cells(k).verticesX > substrateSize/2) || ...
                        any(d.cells(k).verticesX < -substrateSize/2) || ...
                        any(d.cells(k).verticesY > substrateSize/2) || ...
                        any(d.cells(k).verticesY < -substrateSize/2)
                    d = 0;
                    return;
                end
            end
        end
        
        
        % if the simulation is run from the GUI, show a progress dialog
        if isobject(app)
            progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Creating the substrate',...
                'Indeterminate','on');
        end
       
        % create the substrate
        d = create_substrate(app, d,substrateSize);
        
        % if the creation is canceled, return
        if ~isstruct(d); return; end
        
        % save the square substrate
        subTemp = d.sub;
        
        % a multiplier used in removing the extra substrate points for the
        % fitted shape
        expansionMultiplier = 1.5;
        
        % loop until the substrate and focal adhesion data is good for
        % simulation
        while 1
            
            % remove extra points if fitted shape
            if strcmp(app.SubstrateTypeButtonGroup.SelectedObject.Text,'Fitted')
                d = remove_substrate_points(d,app,expansionMultiplier);
                if ~isstruct(d); return; end
            end
            
            % if the simulation is pointlike or optogenetic, ge the
            % substrate spring constants and edge points
            if any(d.simset.simulationType == [2,5])
                d = get_substrate_spring_constants(d,app);
                d = get_substrate_edge_points(d);
            end
            
            % show a progress dialog in the GUI to indicate the focal
            % adhesions are being created
            if isobject(app)
                progressdlg = uiprogressdlg(app.EpiMechUIFigure,'Title','Creating focal adhesions','Indeterminate','on');
            end
            
            % create focal adhesions
            [d, ok] = create_focal_adhesions(d,app);
            
            % if everything is ok
            if ok
                break;
                
            % otherwise, increase the substrate expansion multiplier and
            % load the square substrate and try again (this from the case
            % that there are cell vertices around the substrate area and
            % focal adhesions cannot be defined)
            else
                expansionMultiplier = expansionMultiplier*1.1;
                d.sub = subTemp;
            end
        end
        
        % close GUI progress dialog 
        close(progressdlg);
        
    % if substrate is imported from imported simulation
    elseif strcmp(app.modelCase,'import') && app.UseimportedsubstratedataCheckBox.Value
        
        % import substrate
        d = import_substrate(app,d);
    end
end

end