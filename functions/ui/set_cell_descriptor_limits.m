function set_cell_descriptor_limits(app)

switch app.DescriptorDropDown.Value
    case 'Area'
        app.MinimummagnitudeEditField_2.Limits = [0,Inf];
        app.MaximummagnitudeEditField_2.Limits = [0,Inf];
        app.MinimummagnitudeEditField_2.Value = app.cellDescriptorLimits(1,1);
        app.MaximummagnitudeEditField_2.Value = app.cellDescriptorLimits(1,2);
        app.MinimummagnitudeEditField_2.Enable = 'on';
        app.MaximummagnitudeEditField_2.Enable = 'on';
    case 'Area strain'
        app.MinimummagnitudeEditField_2.Limits = [-Inf,Inf];
        app.MaximummagnitudeEditField_2.Limits = [-Inf,Inf];
        app.MinimummagnitudeEditField_2.Value = app.cellDescriptorLimits(2,1);
        app.MaximummagnitudeEditField_2.Value = app.cellDescriptorLimits(2,2);
        app.MinimummagnitudeEditField_2.Enable = 'on';
        app.MaximummagnitudeEditField_2.Enable = 'on';
    case 'Perimeter'
        app.MinimummagnitudeEditField_2.Limits = [0,Inf];
        app.MaximummagnitudeEditField_2.Limits = [0,Inf];
        app.MinimummagnitudeEditField_2.Value = app.cellDescriptorLimits(3,1);
        app.MaximummagnitudeEditField_2.Value = app.cellDescriptorLimits(3,2);
        app.MinimummagnitudeEditField_2.Enable = 'on';
        app.MaximummagnitudeEditField_2.Enable = 'on';
    case 'Perimeter strain'
        app.MinimummagnitudeEditField_2.Limits = [-Inf,Inf];
        app.MaximummagnitudeEditField_2.Limits = [-Inf,Inf];
        app.MinimummagnitudeEditField_2.Value = app.cellDescriptorLimits(4,1);
        app.MaximummagnitudeEditField_2.Value = app.cellDescriptorLimits(4,2);
        app.MinimummagnitudeEditField_2.Enable = 'on';
        app.MaximummagnitudeEditField_2.Enable = 'on';
    case 'Circularity'
        app.MinimummagnitudeEditField_2.Limits = [0,1];
        app.MaximummagnitudeEditField_2.Limits = [0,1];
        app.MinimummagnitudeEditField_2.Value = app.cellDescriptorLimits(5,1);
        app.MaximummagnitudeEditField_2.Value = app.cellDescriptorLimits(5,2);
        app.MinimummagnitudeEditField_2.Enable = 'on';
        app.MaximummagnitudeEditField_2.Enable = 'on';
    case 'Aspect ratio'
        app.MinimummagnitudeEditField_2.Limits = [1,Inf];
        app.MaximummagnitudeEditField_2.Limits = [1,Inf];
        app.MinimummagnitudeEditField_2.Value = app.cellDescriptorLimits(6,1);
        app.MaximummagnitudeEditField_2.Value = app.cellDescriptorLimits(6,2);
        app.MinimummagnitudeEditField_2.Enable = 'on';
        app.MaximummagnitudeEditField_2.Enable = 'on';
    case 'Angle'
        app.MinimummagnitudeEditField_2.Limits = [-90,90];
        app.MaximummagnitudeEditField_2.Limits = [-90,90];
        app.MinimummagnitudeEditField_2.Value = app.cellDescriptorLimits(7,1);
        app.MaximummagnitudeEditField_2.Value = app.cellDescriptorLimits(7,2);
        app.MinimummagnitudeEditField_2.Enable = 'off';
        app.MaximummagnitudeEditField_2.Enable = 'off';
        
end
        


        
        
        

end