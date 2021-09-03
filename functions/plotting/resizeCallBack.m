function resizeCallBack(~, evd)

height = evd.Source.Position(4)*evd.Source.CurrentAxes.Position(4);
if height < 400
    height = 400;
elseif height > 800
    height = 800;
end
children = allchild(evd.Source.CurrentAxes);

for i = 1:length(children)
   if strcmp(children(i).Type,'text')
       children(1).FontSize = height/30;
   end
end
end