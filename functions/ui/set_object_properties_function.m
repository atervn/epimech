function set_object_properties_function(app,objects,attribute,value)

if length(value) == 1
    for i = 1:length(objects)
        app.(objects{i}).(attribute) = value{1};
    end
else
    for i = 1:length(objects)
        app.(objects{i}).(attribute) = value{i};
    end
end

end

