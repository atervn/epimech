function dt = update_dt(d,dt,time,maxmaxMovement)

if dt < d.spar.maximumTimeStep && maxmaxMovement <= 20e-4*0.1
    multiplier = 2;
else
    multiplier = 1;
end

while 1
    if round( ((floor(time/d.spar.maximumTimeStep+1e-10)*d.spar.maximumTimeStep + d.spar.maximumTimeStep) - (multiplier*dt+time)),10) >= 0
        dt = dt*multiplier;
        break;
    else
        multiplier = multiplier/2;
    end
end

end