function plot_cell_forces(d,forcePlot)

if d.pl.cellForcesCortical
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesCortical(:,3).^2 + forcePlot.cellForcesCortical(:,4).^2);
        scatter(forcePlot.cellForcesCortical(:,1), forcePlot.cellForcesCortical(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesCortical(:,1), forcePlot.cellForcesCortical(:,2), forcePlot.cellForcesCortical(:,3), forcePlot.cellForcesCortical(:,4),'-g')
    end
end
if d.pl.cellForcesJunctions
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesJunctions(:,3).^2 + forcePlot.cellForcesJunctions(:,4).^2);
        scatter(forcePlot.cellForcesJunctions(:,1), forcePlot.cellForcesJunctions(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesJunctions(:,1), forcePlot.cellForcesJunctions(:,2), forcePlot.cellForcesJunctions(:,3), forcePlot.cellForcesJunctions(:,4),'-g')
    end
end
if d.pl.cellForcesDivision
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesDivision(:,3).^2 + forcePlot.cellForcesDivision(:,4).^2);
        scatter(forcePlot.cellForcesDivision(:,1), forcePlot.cellForcesDivision(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesDivision(:,1), forcePlot.cellForcesDivision(:,2), forcePlot.cellForcesDivision(:,3), forcePlot.cellForcesDivision(:,4),'-g')
    end
end
if d.pl.cellForcesMembrane
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesMembrane(:,3).^2 + forcePlot.cellForcesMembrane(:,4).^2);
        scatter(forcePlot.cellForcesMembrane(:,1), forcePlot.cellForcesMembrane(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesMembrane(:,1), forcePlot.cellForcesMembrane(:,2), forcePlot.cellForcesMembrane(:,3), forcePlot.cellForcesMembrane(:,4),'-g')
    end
end
if d.pl.cellForcesContact
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesContact(:,3).^2 + forcePlot.cellForcesContact(:,4).^2);
        scatter(forcePlot.cellForcesContact(:,1), forcePlot.cellForcesContact(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesContact(:,1), forcePlot.cellForcesContact(:,2), forcePlot.cellForcesContact(:,3), forcePlot.cellForcesContact(:,4),'-g')
    end
end
if d.pl.cellForcesArea
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesArea(:,3).^2 + forcePlot.cellForcesArea(:,4).^2);
        scatter(forcePlot.cellForcesArea(:,1), forcePlot.cellForcesArea(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesArea(:,1), forcePlot.cellForcesArea(:,2), forcePlot.cellForcesArea(:,3), forcePlot.cellForcesArea(:,4),'-g')
    end
end
if d.pl.cellForcesPointlike && d.simset.simulationType == 2
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesPointlike(:,3).^2 + forcePlot.cellForcesPointlike(:,4).^2);
        scatter(forcePlot.cellForcesPointlike(:,1), forcePlot.cellForcesPointlike(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesPointlike(:,1), forcePlot.cellForcesPointlike(:,2), forcePlot.cellForcesPointlike(:,3), forcePlot.cellForcesPointlike(:,4),'-g')
    end
end
if d.pl.cellForcesFocalAdhesions && any(d.simset.simulationType == [2,3])
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesFocalAdhesions(:,3).^2 + forcePlot.cellForcesFocalAdhesions(:,4).^2);
        scatter(forcePlot.cellForcesFocalAdhesions(:,1), forcePlot.cellForcesFocalAdhesions(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesFocalAdhesions(:,1), forcePlot.cellForcesFocalAdhesions(:,2), forcePlot.cellForcesFocalAdhesions(:,3), forcePlot.cellForcesFocalAdhesions(:,4),'-g')
    end
end
if d.pl.cellForcesTotal
    if d.pl.plotType == 10
        magnitudes = sqrt(forcePlot.cellForcesTotal(:,3).^2 + forcePlot.cellForcesTotal(:,4).^2);
        scatter(forcePlot.cellForcesTotal(:,1), forcePlot.cellForcesTotal(:,2),d.pl.markerSize,magnitudes,'filled');
        caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
        c = colorbar;
        c.FontSize = 20;
    else
        quiver(d.pl.axesHandle,forcePlot.cellForcesTotal(:,1), forcePlot.cellForcesTotal(:,2), forcePlot.cellForcesTotal(:,3), forcePlot.cellForcesTotal(:,4),'-g')
    end
end
