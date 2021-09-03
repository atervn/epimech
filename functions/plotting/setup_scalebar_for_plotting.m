function pl = setup_scalebar_for_plotting(app,pl,checkBox)

pl.scaleBar.show = app.(checkBox).Value;
if pl.scaleBar.show
    if app.scaleBarSettings.type == 1
        pl.scaleBar.lengths = [app.scaleBarSettings.barLength 1 1000000];
    elseif app.scaleBarSettings.type == 2
        
        if app.scaleBarSettings.barLenghtData == 0
            pl.scaleBar.lengths = [app.scaleBarSettings.barLength 1 1000000];
        else
            pl.scaleBar.lengths = app.scaleBarSettings.barLenghtData;
        end
    end
end

end