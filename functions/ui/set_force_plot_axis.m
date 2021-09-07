function set_force_plot_axis(app,axisLength,axisType,vertical,horizontal)

yax = get(gca,'YAxis');

yLimits = yax.Limits;

if axisLength
    if axisType
        set(gca,'yscale','log')
        
        if max(max(vertical(:)),max(horizontal(:)))*2 > yax.Limits(2)
            yLimits(2) = max(max(vertical(:)),max(horizontal(:)))*2;
        end
        if min(min(vertical(:)),min(horizontal(:)),'omitnan')*0.8 < yax.Limits(1) || yax.Limits(1) == 0
            yLimits(1) = min(min(vertical(:)),min(horizontal(:)),'omitnan')*0.8;
        end
        set(gca,'XLim',[-app.WindowsizeEditField.Value/2 0])
        set(gca,'YLim',yLimits);
    else
        set(gca,'yscale','linear')
        
        if max(max(vertical(:)),max(horizontal(:)))*1.05 > yax.Limits(2)
            yLimits(2) = max(max(vertical(:)),max(horizontal(:)))*1.05;
        end
        yLimits(1) = 0;
        
        set(gca,'XLim',[-app.WindowsizeEditField.Value/2 0])
        set(gca,'YLim',yLimits);
    end
else
    if axisType
        set(gca,'yscale','log')
        
        if max(max(vertical(:)),max(horizontal(:)))*2 > yax.Limits(2)
            yLimits(2) = max(max(vertical(:)),max(horizontal(:)))*2;
        end
        if min(min(vertical(:)),min(horizontal(:)),'omitnan')*0.8 < yax.Limits(1) || yax.Limits(1) == 0
            yLimits(1) = min(min(vertical(:)),min(horizontal(:)),'omitnan')*0.8;
        end
        set(gca,'XLim',[-app.WindowsizeEditField.Value/2 app.WindowsizeEditField.Value/2])
        set(gca,'YLim',yLimits);
    else
        set(gca,'yscale','linear')
        
        if max(max(vertical(:)),max(horizontal(:)))*1.05 > yax.Limits(2)
            yLimits(2) = max(max(vertical(:)),max(horizontal(:)))*1.05;
        end
        yLimits(1) = 0;
        
        set(gca,'XLim',[-app.WindowsizeEditField.Value/2 app.WindowsizeEditField.Value/2])
        set(gca,'YLim',yLimits);
    end
end