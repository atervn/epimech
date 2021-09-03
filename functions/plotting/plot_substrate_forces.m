function plot_substrate_forces(d)

if any(d.simset.simulationType == [2,5])
    if d.pl.substrateForcesDirect
        if d.pl.plotType == 10
            magnitudes = sqrt(d.sub.forces.directX.^2 + d.sub.forces.directY.^2);
            scatter(d.sub.pointsX, d.sub.pointsY,d.pl.markerSize,magnitudes,'filled');
            caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
            c = colorbar;
            c.FontSize = 20;
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.directX, 0.01.*d.sub.forces.directY,'-m','AutoScale', 'off')
        end
    end
    if d.pl.substrateForcesRepulsion
        if d.pl.plotType == 10
            magnitudes = sqrt(d.sub.forces.boundaryRepulsionX.^2 + d.sub.forces.boundaryRepulsionY.^2);
            scatter(d.sub.pointsX, d.sub.pointsY,d.pl.markerSize,magnitudes,'filled');
            caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
            c = colorbar;
            c.FontSize = 20;
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.boundaryRepulsionX, 0.01.*d.sub.forces.boundaryRepulsionY,'-m','AutoScale', 'off')
        end
    end
    if d.pl.substrateForcesRestoration
        if d.pl.plotType == 10
            magnitudes = sqrt(d.sub.forces.restorativeX.^2 + d.sub.forces.restorativeY.^2);
            scatter(d.sub.pointsX, d.sub.pointsY,d.pl.markerSize,magnitudes,'filled');
            caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
            c = colorbar;
            c.FontSize = 20;
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.restorativeX, 0.01.*d.sub.forces.restorativeY,'-m','AutoScale', 'off')
        end
    end
    if d.pl.substrateForcesFocalAdhesions
        if d.pl.plotType == 10
            magnitudes = sqrt(d.sub.forces.focalAdhesionsX.^2 + d.sub.forces.focalAdhesionsY.^2);
            scatter(d.sub.pointsX, d.sub.pointsY,d.pl.markerSize,magnitudes,'filled');
            caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
            c = colorbar;
            c.FontSize = 20;
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.focalAdhesionsX, 0.01.*d.sub.forces.focalAdhesionsY,'-m','AutoScale', 'off')
        end
    end
    if d.pl.substrateForcesTotal
        if d.pl.plotType == 10
            magnitudes = sqrt(d.sub.forces.totalX.^2 + d.sub.forces.totalY.^2);
            scatter(d.sub.pointsX, d.sub.pointsY,d.pl.markerSize,magnitudes,'filled');
            caxis([d.pl.minMagnitude d.pl.maxMagnitude]);
            c = colorbar;
            c.FontSize = 20;
        else
            quiver(d.pl.axesHandle,d.sub.pointsX, d.sub.pointsY, 0.01.*d.sub.forces.totalX, 0.01.*d.sub.forces.totalY,'-m','AutoScale', 'off')
        end
    end
end