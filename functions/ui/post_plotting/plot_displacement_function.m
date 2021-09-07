function plot_displacement_function(d, app, time)

d.pl.axesHandle = cla;

hold on

switch d.pl.displacementPlot
    case 'cells'
        centersX = [];
        centersY = [];
        displacements = [];
        vectX = [];
        vectY = [];
        for k = 1:length(d.cells)
            centerX = mean(d.pl.initialCells(k).verticesX);
            centerY = mean(d.pl.initialCells(k).verticesY);
            displacement = sqrt((centerX - mean(d.cells(k).verticesX)).^2 + (centerY - mean(d.cells(k).verticesY)).^2);
            
            centersX = [centersX ; centerX]; %#ok<AGROW>
            centersY = [centersY ; centerY]; %#ok<AGROW>
            displacements = [displacements ; displacement]; %#ok<AGROW>
            vectX = [vectX; mean(d.cells(k).verticesX)-centerX]; %#ok<AGROW>
            vectY = [vectY; mean(d.cells(k).verticesY)-centerY]; %#ok<AGROW>
            
        end
        
        displacements = displacements*d.spar.scalingLength/1e-6;
        
        [xq,yq] = meshgrid(d.pl.axisLimits(1):(d.pl.axisLimits(2)-d.pl.axisLimits(1))*0.001:d.pl.axisLimits(2),...
            d.pl.axisLimits(3):(d.pl.axisLimits(4)-d.pl.axisLimits(3))*0.001:d.pl.axisLimits(4));
        
        z1 = griddata(centersX,centersY,displacements,xq,yq,'cubic');
        contourf(xq,yq,z1,[1 2 5 10 15],'LineColor','none');
        mymap = csvread([app.defaultPath 'settings/Misc/mymap.csv']);
        colormap(mymap)
        colorbar
        caxis([0, d.pl.displacementMax])
        
%         quiver(centersX,centersY,vectX,vectY,0,'-w')
        try

            d = import_pointlike_data(app,d);
            
            [~, idxx] = min(abs((d.pl.axisLimits(1):(d.pl.axisLimits(2)-d.pl.axisLimits(1))*0.001:d.pl.axisLimits(2)) - centersX(d.simset.pointlike.cell)));
            [~, idxy] = min(abs((d.pl.axisLimits(3):(d.pl.axisLimits(4)-d.pl.axisLimits(3))*0.001:d.pl.axisLimits(4)) - centersY(d.simset.pointlike.cell)));
            
            
            
            figure(2);
            subplot(1,2,1);
            idx = idxx:-1:1;
            points = (1:length(idx)).*0.0125*20;
            plot(points,z1(idxy,idx))
            axis([0 100 0 16])

            subplot(1,2,2);
            idx = idxy:-1:1;
            points = (1:length(idx)).*0.0125*20;
            plot(points,z1(idx,idxx))
            axis([0 100 0 16])
            
        catch
        end
        
    case 'substrate'
        displacements = sqrt((d.sub.pointsX - d.sub.pointsOriginalX).^2 + (d.sub.pointsY - d.sub.pointsOriginalY).^2)*d.spar.scalingLength/1e-6;

%         [xq,yq] = meshgrid((-1:0.01:1)*d.pl.windowSize/d.spar.scalingLength);
        [xq,yq] = meshgrid(d.pl.axisLimits(1):(d.pl.axisLimits(2)-d.pl.axisLimits(1))*0.001:d.pl.axisLimits(2),...
            d.pl.axisLimits(3):(d.pl.axisLimits(4)-d.pl.axisLimits(3))*0.01:d.pl.axisLimits(4));
        
        z1 = griddata(d.sub.pointsOriginalX,d.sub.pointsOriginalY,displacements,xq,yq,'cubic');
        contourf(xq,yq,z1,256,'LineColor','none');
        mymap = csvread('./settings/Misc/mymap.csv');
        colormap(mymap)
        colorbar
        caxis([0, d.pl.displacementMax])
end

%% TITLE

plot_title(d,time,0,0);

%% SCALEBASR

plot_scale_bar(d)

hold off

drawnow

close(d.pl.progressdlg);

end
