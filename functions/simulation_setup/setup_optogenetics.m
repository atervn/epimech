function d = setup_optogenetics(app,d)

if d.simset.simulationType == 5
    d.simset.opto.times = [app.optoActivation(:,1) ; 1e12]./d.spar.scalingTime;
    d.simset.opto.levels = [app.optoActivation(:,2); app.optoActivation(end,2)].*d.spar.fullActivationConstant;
    d.simset.opto.shapes = app.optoShapes;
    d.simset.opto.cells = app.optoVertices.cells;
    d.simset.opto.vertices = app.optoVertices.vertices;
    d.simset.opto.currentTime = 1;
end

end