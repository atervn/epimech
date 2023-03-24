function forcePlot = plot_initilize_force_matrices(d)
% PLOT_INITIALIZE_FORCE_MATRICES Initialize matrices to collect force data
%   The function initializes matrices that are used to collect data for the
%   cell vertex forces that are to be plotted.
%   INPUTS:
%       d: main simulation data structure
%   OUTPUT:
%       forcePlot: structure of force matrices
%   by Aapo Tervonen, 2021

% initialize structure for the force matrices
forcePlot = struct();

% if cortical forces are plotted
if d.pl.cellForcesCortical
    forcePlot.cellForcesCortical = [];
end

% if junction forces are plotted
if d.pl.cellForcesJunctions
    forcePlot.cellForcesJunctions = [];
end

% if division forces are plotted
if d.pl.cellForcesDivision
    forcePlot.cellForcesDivision = []; 
end

% if membrane forces are plotted
if d.pl.cellForcesMembrane
    forcePlot.cellForcesMembrane = [];
end

% if contact forces are plotted
if d.pl.cellForcesContact
    forcePlot.cellForcesContact = [];  
end

% if area forces are plotted
if d.pl.cellForcesArea
    forcePlot.cellForcesArea = [];
end

% if pointlike forces are plotted (and simulation is pointlike)
if d.pl.cellForcesPointlike && d.simset.simulationType == 2
    forcePlot.cellForcesPointlike = [];
end

% if focal adhesion forces are plotted (and substrate is included in the
% simulation)
if d.pl.cellForcesFocalAdhesions && d.simset.substrateIncluded
    forcePlot.cellForcesFocalAdhesions = [];
end

% if total forces are plotted
if d.pl.cellForcesTotal
    forcePlot.cellForcesTotal = [];
end

end