function set_disp_plot_axis(axisLength,axisType,xLimit,yMin,yMax)

if axisLength
    if axisType
        set(gca,'yscale','log')
        axis([-xLimit 0 yMin yMax])
    else
        set(gca,'yscale','linear')
        axis([-xLimit 0 0 yMax])
    end
else
    if axisType
        set(gca,'yscale','log')
        axis([-xLimit xLimit yMin yMax])
    else
        set(gca,'yscale','linear')
        axis([-xLimit xLimit 0 yMax])
    end
end

end
