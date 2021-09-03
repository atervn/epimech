function simset = progress_bar(app,currentTime,spar,simset)

percentage = currentTime/spar.simulationTime;

if percentage*100 >= simset.percentVariable
    percentageString = sprintf('%0.1f %%',percentage*100);
    app.SimulationprogressLabel.Text = percentageString;
    simset.percentVariable = simset.percentVariable + 0.1;
else
    return
end

if floor(percentage*50) >= simset.progressVariable
    app.ProgressLabel.Text = [app.ProgressLabel.Text 'l'];
    simset.progressVariable = simset.progressVariable + 1;
end

currentTime = currentTime*spar.scalingTime;

switch app.simulationType
    case 'growth'
        
        if currentTime < 60
            seconds = currentTime;
            minutes = 0;
            hours = 0;
            days = 0;
        elseif currentTime < 60*60
            minutes = floor(round(currentTime,1)/60);
            seconds = currentTime - minutes*60;
            hours = 0;
            days = 0;
        elseif currentTime < 60*60*24
            hours = floor(currentTime/(60*60));
            minutes = floor(currentTime/60 - hours*60);
            seconds = currentTime - minutes*60 - hours*60*60;
            days = 0;
        else
            days = floor(currentTime/(60*60*24));
            hours = floor(currentTime/(60*60) - days*24);
            minutes = floor(currentTime/60 - hours*60 - days*24*60);
            seconds = currentTime - minutes*60 - hours*60*60 - days*24*60*60;
        end
        
        
        msg = sprintf('%02.f-%02.f:%02.f:%02.f / %02.f:%02.f:%02.f:%02.f',days,hours,minutes,seconds,simset.simulationTime.days,simset.simulationTime.hours,simset.simulationTime.minutes,simset.simulationTime.seconds);
    case 'pointlike'
        msg = sprintf('%2.4f / %2.4f s',floor(currentTime*10000)/10000,simset.simulationTime.seconds);
    case 'opto'
        msg = sprintf('%2.4f / %2.4f s',floor(currentTime*10000)/10000,simset.simulationTime.seconds);
end

app.SimulationprogresstimeLabel.Text = msg;