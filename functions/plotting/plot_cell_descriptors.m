function plot_cell_descriptors(d,k)

switch d.pl.cellStyle
    case 7
        d.cells(k) =  get_cell_areas(d.cells(k));
        feature = d.cells(k).area*d.spar.scalingLength^2*1e12;

        %         colorbar
        %         caxis([d.pl.minMagnitude d.pl.maxMagnitude])
    case 8
        d.cells(k) =  get_cell_areas(d.cells(k));
        feature = (d.cells(k).area - d.cells(k).normArea)/d.cells(k).normArea;

        
    case 9
        d.cells(k) =  get_boundary_vectors(d.cells(k));
        d.cells(k) =  get_boundary_lengths(d.cells(k));
        d.cells(k) =  get_cell_perimeters(d.cells(k));
        feature = d.cells(k).perimeter*d.spar.scalingLength*1e6;

        
    case 10
        d.cells(k) =  get_boundary_vectors(d.cells(k));
        d.cells(k) =  get_boundary_lengths(d.cells(k));
        d.cells(k) =  get_cell_perimeters(d.cells(k));
        feature = (d.cells(k).perimeter - d.cells(k).normPerimeter)/d.cells(k).normPerimeter;

    case 11
        d.cells(k) =  get_boundary_vectors(d.cells(k));
        d.cells(k) =  get_boundary_lengths(d.cells(k));
        d.cells(k) =  get_cell_perimeters(d.cells(k));
        d.cells(k) =  get_cell_areas(d.cells(k));
        feature = 4*pi*d.cells(k).area/d.cells(k).perimeter^2;

    case 12
        ellipseData = fit_ellipse(d.cells(k).verticesX,d.cells(k).verticesY);
        feature = ellipseData.long_axis/ellipseData.short_axis;

    case 13
        ellipseData = fit_ellipse(d.cells(k).verticesX,d.cells(k).verticesY);
        feature = ellipseData.phi*180/pi;

end
if feature < min(d.pl.colorLocations)
    color = d.pl.colormap(1,:);
elseif feature > max(d.pl.colorLocations)
    color = d.pl.colormap(end,:);
else
    color = interp1(d.pl.colorLocations,d.pl.colormap,feature);
end
fill(d.pl.axesHandle,d.cells(k).verticesX,d.cells(k).verticesY,color, 'linewidth', 0.5, 'edgecolor', [0 0 0])

end