function d = setup_stretching_settings(app,d)
% SETUP_STRETCHING_SETTINGS Setup settings for lateral compression or
% stretching
%   The function defines the settings for the lateral compression or
%   stretching simulation based on the user input.
%   INPUT:
%       app: main application object
%       d: main simulation data structure
%   OUTPUT:
%       d: main simulation data structure
%   by Aapo Tervonen, 2021

% check if stretching simulation
if d.simset.simulationType == 3
    
    % if the stretch type is piecewise
    if app.stretch.type == 1
        
        % get the defined stretch time points (and add an time point to the
        % end to make sure the last time point is not before the simulation
        % end time) and scale it with the scaling time
        d.simset.stretch.times = [app.stretch.piecewise(:,1); 2*d.spar.simulationTime.*d.spar.scalingTime]./d.spar.scalingTime;
        
        % get values at the stretch time points (and duplicate the last
        % value so the stretch remains the same after the last define point
        d.simset.stretch.values = [app.stretch.piecewise(:,2); app.stretch.piecewise(end,2)];
    
    % if the stretch type is sine
    else
        
        % get the stretch time step (either 0.001 or sixtieth of the sine
        % wave period, whichever is smaller)
        dt = min(0.001,1./(app.stretch.sine(2).*d.spar.scalingTime)./60);
        
        % get the stretch times, going a bit over the simulation time
        d.simset.stretch.times = 0:dt:(d.spar.simulationTime*1.1);
        
        % get the stretch value at given times based on the amplitude,
        % frequency and the phase
        d.simset.stretch.values = 1 + app.stretch.sine(1).*sin(2.*pi.*app.stretch.sine(2).*d.simset.stretch.times.*d.spar.scalingTime + app.stretch.sine(3));
    end
    
    % set the number of stretch axes
    switch app.CompressionAxisButtonGroup.SelectedObject.Text
        case 'Uniaxial'
            d.simset.stretch.axis = 1;
        case 'Biaxial'
            d.simset.stretch.axis = 2;
    end
end

end