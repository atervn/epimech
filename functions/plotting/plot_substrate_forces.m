function plot_substrate_forces(d)
% PLOT_SUBSTRATE_FORCES Plot the forces on the substrate points
%   The function plots that selected forces affecting the substrate points
%   either as arrows or based on magnitude (only post plotting). In the
%   magnitude plots, the force is indicated by a colored circle at the
%   point coordinates
%   INPUTS:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% if the simulation can contain substrate forces (i.e. pointlike or
% optogenetic)
if d.simset.substrateSolved
    
    plotForceMagnitude = 0;
    
    % if central forces are plotted
    if d.pl.substrateForcesCentral
        
        % if only the magnitude is plotted
        if d.pl.plotType == 4
            magnitudes = sqrt(d.sub.forces.centralX.^2 + d.sub.forces.centralY.^2);
             plotForceMagnitude = 1;
            
        % if arrow plot
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.centralX, 0.01.*d.sub.forces.centralY,'-m','AutoScale', 'off')
        end
    end
    
    % if repulsion forces are plotted
    if d.pl.substrateForcesRepulsion
        
        % if only the magnitude is plotted
        if d.pl.plotType == 4
            magnitudes = sqrt(d.sub.forces.repulsionX.^2 + d.sub.forces.repulsionY.^2);
             plotForceMagnitude = 1;
            
        % if arrow plot
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.repulsionX, 0.01.*d.sub.forces.repulsionY,'-m','AutoScale', 'off')
        end
    end
    
    % if restorative forces are plotted
    if d.pl.substrateForcesRestoration
        
        % if only the magnitude is plotted
        if d.pl.plotType == 4
            magnitudes = sqrt(d.sub.forces.restorativeX.^2 + d.sub.forces.restorativeY.^2);
             plotForceMagnitude = 1;
            
        % if arrow plot
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.restorativeX, 0.01.*d.sub.forces.restorativeY,'-m','AutoScale', 'off')
        end
    end
    
    % if focal adhesion forces are plotted
    if d.pl.substrateForcesFocalAdhesions
        
        % if only the magnitude is plotted
        if d.pl.plotType == 4
            magnitudes = sqrt(d.sub.forces.focalAdhesionsX.^2 + d.sub.forces.focalAdhesionsY.^2);
             plotForceMagnitude = 1;
            
        % if arrow plot
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.focalAdhesionsX, 0.01.*d.sub.forces.focalAdhesionsY,'-m','AutoScale', 'off')
        end
    end
    
    % if total substrate forces are plotted
    if d.pl.substrateForcesTotal
        
        % if only the magnitude is plotted
        if d.pl.plotType == 4
            magnitudes = sqrt(d.sub.forces.totalX.^2 + d.sub.forces.totalY.^2);
             plotForceMagnitude = 1;
            
        % if arrow plot
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.totalX, 0.01.*d.sub.forces.totalY,'-m','AutoScale', 'off')
        end
    end
    
    % if only the magnitude is plotted
    if d.pl.plotType == 4 && plotForceMagnitude
        scatter(d.pl.axesHandle, d.sub.pointsX, d.sub.pointsY,d.pl.markerSize,magnitudes,'filled');
        
        % set the colorbar limits and show the colorbar
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    end
end

end