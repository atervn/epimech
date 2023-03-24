function plot_cell_forces(d,forcePlot)
% PLOT_CELL_FORCES Plot the defined cell forces
%   The function plots the cells forces either as arrows from the cell
%   vertices or as dots with the color indicating the magnitude of the
%   force
%   INPUTS:
%       d: main simulation data structure
%       forcePlot: structure with the vertex coordinates and force
%       components
%   by Aapo Tervonen, 2021

% if cortical forces are plotted
if d.pl.cellForcesCortical
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesCortical(:,3).^2 + forcePlot.cellForcesCortical(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesCortical(:,1), forcePlot.cellForcesCortical(:,2),d.pl.markerSize,magnitudes,'filled');
        
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesCortical(:,1), forcePlot.cellForcesCortical(:,2), forcePlot.cellForcesCortical(:,3), forcePlot.cellForcesCortical(:,4),'-g')
    end
end

% if junction forces are plotted
if d.pl.cellForcesJunctions
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesJunctions(:,3).^2 + forcePlot.cellForcesJunctions(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesJunctions(:,1), forcePlot.cellForcesJunctions(:,2),d.pl.markerSize,magnitudes,'filled');
    
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesJunctions(:,1), forcePlot.cellForcesJunctions(:,2), forcePlot.cellForcesJunctions(:,3), forcePlot.cellForcesJunctions(:,4),'-g')
    end
end

% if division forces are plotted
if d.pl.cellForcesDivision
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesDivision(:,3).^2 + forcePlot.cellForcesDivision(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesDivision(:,1), forcePlot.cellForcesDivision(:,2),d.pl.markerSize,magnitudes,'filled');
    
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesDivision(:,1), forcePlot.cellForcesDivision(:,2), forcePlot.cellForcesDivision(:,3), forcePlot.cellForcesDivision(:,4),'-g')
    end
end

% if membrane forces are plotted
if d.pl.cellForcesMembrane
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesMembrane(:,3).^2 + forcePlot.cellForcesMembrane(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesMembrane(:,1), forcePlot.cellForcesMembrane(:,2),d.pl.markerSize,magnitudes,'filled');
    
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesMembrane(:,1), forcePlot.cellForcesMembrane(:,2), forcePlot.cellForcesMembrane(:,3), forcePlot.cellForcesMembrane(:,4),'-g')
    end
end

% if contact forces are plotted
if d.pl.cellForcesContact
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesContact(:,3).^2 + forcePlot.cellForcesContact(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesContact(:,1), forcePlot.cellForcesContact(:,2),d.pl.markerSize,magnitudes,'filled');
    
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesContact(:,1), forcePlot.cellForcesContact(:,2), forcePlot.cellForcesContact(:,3), forcePlot.cellForcesContact(:,4),'-g')
    end
end

% if area forces are plotted
if d.pl.cellForcesArea
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesArea(:,3).^2 + forcePlot.cellForcesArea(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesArea(:,1), forcePlot.cellForcesArea(:,2),d.pl.markerSize,magnitudes,'filled');
    
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesArea(:,1), forcePlot.cellForcesArea(:,2), forcePlot.cellForcesArea(:,3), forcePlot.cellForcesArea(:,4),'-g')
    end
end

% if pointlike forces are plotted
if d.pl.cellForcesPointlike && d.simset.simulationType == 2
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesPointlike(:,3).^2 + forcePlot.cellForcesPointlike(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesPointlike(:,1), forcePlot.cellForcesPointlike(:,2),d.pl.markerSize,magnitudes,'filled');
    
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesPointlike(:,1), forcePlot.cellForcesPointlike(:,2), forcePlot.cellForcesPointlike(:,3), forcePlot.cellForcesPointlike(:,4),'-g')
    end
end

% if focal adhesion forces are plotted
if d.pl.cellForcesFocalAdhesions && d.simset.substrateIncluded
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesFocalAdhesions(:,3).^2 + forcePlot.cellForcesFocalAdhesions(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesFocalAdhesions(:,1), forcePlot.cellForcesFocalAdhesions(:,2),d.pl.markerSize,magnitudes,'filled');
    
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesFocalAdhesions(:,1), forcePlot.cellForcesFocalAdhesions(:,2), forcePlot.cellForcesFocalAdhesions(:,3), forcePlot.cellForcesFocalAdhesions(:,4),'-g')
    end
end

% if total forces are plotted
if d.pl.cellForcesTotal
    
    % if this is a magnitude plot
    if d.pl.plotType == 4
        
        % calculate the magnitude
        magnitudes = sqrt(forcePlot.cellForcesTotal(:,3).^2 + forcePlot.cellForcesTotal(:,4).^2);
        
        % plot the magnitudes
        scatter(forcePlot.cellForcesTotal(:,1), forcePlot.cellForcesTotal(:,2),d.pl.markerSize,magnitudes,'filled');
    
    % if arrow plot
    else
        
        % plot the forces
        quiver(d.pl.axesHandle,forcePlot.cellForcesTotal(:,1), forcePlot.cellForcesTotal(:,2), forcePlot.cellForcesTotal(:,3), forcePlot.cellForcesTotal(:,4),'-g')
    end
end

% if magnitude plot
if d.pl.plotType == 4
    
    % set the colorbar settings
    caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
    c = colorbar;
    c.FontSize = 20;
end
