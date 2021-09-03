function write_file(ex, data, name, number, varargin)

if numel(varargin) == 0
    csvwrite([ex.defaultPath '/results/', ex.exportName '/' name '/' name '_'  number '.csv'], data);
else
    csvwrite([ex.defaultPath '/results/', ex.exportName '/' varargin{1} '/' name '_'  number '.csv'], data);
end