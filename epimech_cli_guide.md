# Guide to using EpiMech with command line

The Epimech model can be run without the GUI using command
`epimech(config_file)`, where `config_file` is an input configuration
.txt file used to define the settings for the simulations. This input
file must have the format given below in the example file:

``` {.matlab language="Matlab"}
% -------------------------------------------------------

% simulation type
growth

% number of cores
4

% number of simulations
8

% system parameters
./parameters/system_parameters_growth.txt

% cell parameters
./parameters/cell_parameters.txt ./parameters/specific_parameters_growth.txt

% substrate parameters

% initial state
./results/20201106_134610_g1106.zip

% simulation time
15 d 60 s

% simulation specific input
mdck

% parameter study
fCortex * 0.1,0,2,0.3,0.4,0.5,0.6,0.7,0.8

% export settings
480 ./settings/export/export_options_import_growth.txt

% simulation names
cortex_testing

% -------------------------------------------------------
% comments
```

## Simulation type

Specify the type of your simulation under the `% simulation type`. The
type can either be `growth` (grow epithelia), `pointlike`
(micromanipulation simulations), `opto` (optogenetic simulations), or
`stretch` (lateral stretching or compression). Each simulation defined
in the config file must have the same simulation type. There must be an
empty line before `% number of cores`.

## Number of cores

Specify the number of CPU cores you want under the `% number of cores`
to be used. One simulation is run on one core at a time. The number is
compared against the total number of cores in the CPU to make sure there
are enough of cores available. There must be an empty line before
`% number of simulations`.

## Number of simulations

Specify the number of simulations you want to run under the
`% number of simulations`. There must be an empty line before
`% system parameters`.

## System parameters

Specify the system parameter file name(s) including the path from the
current folder under the `% system` `parameters`. Many files can be
specified on their own lines. The number of specified files has to be
either 1 (used for all simulations) or equal the number of simulations
specified, if different files are to be used. The user can also replace
the file name lines with `load`, and a dialog box is opened to choose
the system parameter file for all simulations (given only once) or for
individual simulations (given for each line for the number of
simulations). There must be an empty line before `% cell parameters`.

## Cell parameters

Specify the cell parameter and simulation type specific cell parameter
file name(s) including the path from the current folder under the
`% cell parameters`. Specify these two files in a same line separated by
a space. Many sets of these two files can be specified by having each
set on their own line. The number of specified sets has to be either 1
(used for all simulations) or equal the number of simulations, if
different files are to be used. The user can also replace the file name
lines with `load` (one per line), and a dialog box is opened to choose
the cell and simulation specific cell parameter files for all
simulations (given only once) or for individual simulations (given for
each line for the number of simulations). There must be an empty line
before `% substrate parameters`.

## Substrate parameters

If a simulation type requires the definition of the substrate parameters
(pointlike or opto), they must be defined here. Otherwise this is left
empty. The line defining the substrate parameters begins with the
stiffness type, which is either `uniform`, `gradient`, or
`heterogenous`. Each of these have their own specific requirements for
the following definitions:

-   For **uniform**, the line would be
    `uniform [stiffness in Pa] [substrate parameter file] [FA parameter file]`
    The uniform requires the definition of the stiffness in Pascals
    (e.g. 1100) after a space, followed by another space and the file
    name with the path from the current folder for the substrate
    parameter file. Finally, the file name with the path from the
    current folder to a file defining the focal adhesion (FA) parameters
    is required. The file names can be replace by `load` to select the
    file using a dialog box (one for each).

-   For **gradient**, the line would be
    `gradient [gradient information file] [substrate parameter file] [FA parameter`
    `file]` The gradient requires the input of a gradient information
    file that specifies how the stiffness changes and the substrate
    parameter file. Finally, the name of a file defining the focal
    adhesion (FA) parameters is required. All of these files must be
    given with path relative to the current folder or they can both be
    replaced by `load` (one for each) so the they can be selected using
    the dialog box.

-   For **heterogeneous** the line would be
    `heterogeneous [stiffness in Pa] [heterogeneous information file] [substrate`
    ` parameter file] [FA parameter file]` The heterogeneous requires
    the input of the mean stiffness (in Pa) and a heterogeneous
    information file that specifies how the stiffness changes, the
    substrate parameter file, and the focal adhesion parameter file. All
    of these files must be given with path relative to the current
    folder or they can both be replaced by `load` (one for each) so the
    they can be selected using the dialog box.

The number of specified sets has to be either 1 (used for all
simulations) or equal the number of simulations, if different files are
to be used. Different substrate stiffness types can be used in the same
simulation config file. There must be an empty line before
`% initial state`.

## Initial state

Specify the previous simulations used as the initial state for the
simulation. If a totally new simulation is conducted, this can be left
empty. If a input is defined, it should be of the type
`[initial file name] [parameter flag] [cell removal flag]` The initial
file name is replaced by the name (including the path relative to the
current folder) of the .zip simulation file. The file name can also be
replaced by `load` to select the file using a dialog box.

The parameter flag (`0` or `1`) defines if the cell parameters that are
used in the simulation are taken from the cell parameter file defined in
the simulation config file (`0`) or from the provided initial simulation
file (`1`).

The cell removal flag is not required, but can be used to remove cells
to reduce the size of the epithelium. There are two different shapes
that can be used in the removal, circle and square, whose size is also
defined. The flag has to be of a type `[shape][size]` (no space), where
`[shape]` is either `c` (circle) or `s` (square) and the `[size]` is the
diameter (circle) or side length (square) in $\mu$m. The shapes are
centered to coordinates (0,0). For example, if a circular area with the
diameter of 250 $\mu$m is to be removed, this flag would be `c250`.

The number of specified sets has to be either 0 (all simulations started
from a single cell), 1 (used for all simulations) or equal the number of
simulations, if different files are to be used.

There are some limitations on which type of initial state simulations
can be used for each simulation type. Growth type simulation always
required growth type initial state. Pointlike type requires either
growth or pointlike. Both opto and stretch require growth type initial
state.

There must be an empty line before `% simulation time`.

## Simulation time

Specify the simulation time and the maximum time step. In addition, for
growth simulations, the time to stop cells dividing can be defined. The
line must be of a type
`[simulation time] [unit] [max time step] [unit] [stop division time] [unit]`
The simulation time, max time step, and stop division time are given as
positive numbers. The units are used to specify the time units for the
provided numbers, and they can be `d` (days), `h` (hours), `m`
(minutes), `s` (seconds), or `ms` (milliseconds). For example, to
simulate 12 days with the maximum time step of 1 minute, the line would
be `12 d 1 m`. The stop division time can be used to end growth before
the full simulated time to make sure there are no dividing cells left in
the epithelium. Currently, the same time is used for all the defined
simulations. There should be an empty line before
`% simulation specific input`.

## Simulation time

Specify the settings specific for each type of simulation.

-   For **growth**, the type of cell area must be defined. This can be
    `mdck` (areas taken from the experimental mdck area data) or
    `uniform` (uniform cell areas with the size defined by the cell
    radius given in the cell parameters). The number of specified types
    has to be either 1 (used for all simulations) or equal the number of
    simulations. If the simulation is started from a previous growth
    simulation, this setting does nothing.

-   For **pointlike**, the user must specify the number of the cell that
    is to be micromanipulated as well as the file describing the pipette
    movement. The line should be of the form
    `[cell number] [pipette movement file]` Here, the cell number should
    be smaller or equal to the number of cells in the initial state or
    zero. If zero is used, the cell closest to the coordinates (0,0) is
    moved. The pipette movement file should contain the path relative to
    the current folder and can be replaced by `load` to choose the filed
    using a dialog box. The number of pointlike settings should be 1 or
    equal the number of simulations.

-   For **opto**, the user must specify the activation profile used in
    the simulation and the areas of activation. The settings should be
    given in a form `[activation file] [activation area file]` Both
    files should be given with path relative to the current folder and
    can be replaced with `load` (one for each )to choose them using a
    dialog box. The number of opto settings should be 1 or equal the
    number of simulations.

-   For **stretch**, the user must specify the direction of the stretch
    or compression, the type of the movement, and a file defining the
    movement. Each line should be of the form
    `[direction] [movement type] [movement information file]` The
    movement direction must be either `uni` (uni directional) or `bi`
    (bidirectional). The movement type must be either `piecewise`
    (defined by linear piecewise functions) or `sine` (defined by a sine
    wave). The movement information file should correspond to the
    specified movement type and must be given with path in relation to
    the current folder. The number of stretch settings should be 1 or
    equal the number of simulations

There should be an empty line before `% parameter study`.

## Parameter study

This is an optional setting that can be used to specify different values
for a single parameter for each simulation without the need to provide
multiple different parameter files. The line should be of the form
`[parameter name] [operation] [values]` The `[parameter name]` must be
one of the system, cell, specific cell, or substrate parameters. The
`[operation]` defined how the parameter values are defined and can
either `*` (multiply) or `=` (equals). The multiply uses the provided
values to multiply the parameter value that was defined in the parameter
files to obtain the parameter to use. The equals uses the provided
parameters directly. The `[values]` contains a list of values separated
by commas (not spaces) to be used. The number of the values should
correspond to the number of simulations.

Examples:

-   To run a parameter study with cortical force with values of half,
    twice, and four times the original value, the line would be
    `fCortex * 0.5,2,4`

-   To run a parameter study with normal junction lengths of 0.5, 1, 2,
    and 5 $\mu$m, the line would be
    `junctionLength = 0.5e-6,1e-6,2e-6,5e-6`

There should be an empty line before `% export settings`.

## Export settings

Specify the settings that are used to export the data. The line should
be of the form `[export time step] [export settings file]` The
`[export time step]` is used to specify a multiplier that defined at
which full time steps (defined by the maximum time step value) the
results are exported. For example, if the maximum time step is 1 minute,
to export data every 8 hours, the export time step would be `480`. The
`[export settings file]` defined the file name including the relative
path to the current folder for a file that contains the information on
what is to be exported. The number of specified sets has to be either 1
(used for all simulations) or equal the number of simulations, if
different files are to be used. There must be an empty line before
`% simulation names`.

## Simulation names

Specify the output names of the simulations. Each name will be prefixed
with the start time of the simulation (`YYYYMMDD_HHMMSS_`) that is same
of all simulations. If left empty, the name of the simulation will be
`YYYYMMDD_HHMMSS_simulation`. The number of the names must be either 1
or the number of the simulations. If only 1 names is provided with
multiple simulations, the output name will a postfix with the simulation
order number (`_N`). If multiple output names are provided, they must
all be unique to prevent overwriting.

## Comment sections

In the config file, there can be comments or titles defined before the
definition of the simulation type. All the `%`, since the first empty
line will be considered to be the one above the line
`% simulation type`. More comments can be provided below the
`% simulation names` and there are no requirements on the comments
symbols etc. This section can be e.g. used to copy paste config lines
for future use.

## A1 Example growth system parameter file

``` {.matlab language="Matlab"}
eta,5
    scalingLength,2e-05
    scalingTime,1
    simulationTime,432000
    maximumTimeStep,60
    stopDivisionTime,950400
    cellMaximumMovement,2e-06
    cellMinimumMovement,2e-07
    junctionModificationTimeStep,10
```

## A2 Example pointlike system parameter file

``` {.matlab language="Matlab"}
eta,1e-05
    scalingLength,2e-05
    scalingTime,1
    simulationTime,1
    maximumTimeStep,0.0001
    cellMaximumMovement,2e-06
    cellMinimumMovement,2e-07
    substrateMaximumMovement,5e-10
    substrateMinimumMovement,5e-11
    fPointlike,0.022
```

## A3 Example opto system parameter file

``` {.matlab language="Matlab"}
eta,0.5
    scalingLength,2e-05
    scalingTime,1
    simulationTime,2400
    maximumTimeStep,1
    cellMaximumMovement,2e-06
    cellMinimumMovement,2e-07
    substrateMaximumMovement,2e-07
    substrateMinimumMovement,2e-08
    junctionModificationTimeStep,1
    fullActivationConstant,4.5
```

## A4 Example stretch system parameter file

``` {.matlab language="Matlab"}
eta,0.5
    scalingLength,2e-05
    scalingTime,1
    simulationTime,1800
    maximumTimeStep,1
    cellMaximumMovement,2e-06
    cellMinimumMovement,2e-07
    junctionModificationTimeStep,1
```

## A5 Example cell parameter file

``` {.matlab language="Matlab"}
rCell,5.79e-06
    membraneLength,1e-06
    junctionLength,1e-06
    fArea,0.04
    fCortex,0.001
    fJunctions,0.04
    fContact,0.02
    perimeterConstant,120
    perimeterModelingRate,0.00315
    minimumCellSize,10e-12
```

## A6 Example growth cell specific parameter file

``` {.matlab language="Matlab"}
fMembrane,0.0001
    fDivision,1e-08
    divisionTimeMean,72000
    divisionTimeSD,14400
    maximumGrowthTime,28800
    maximumDivisionTime,3600
    divisionDistanceConstant,0.4
    newCellAreaConstant,1.055
    cellGrowthConstant,2
    cellGrowthForceConstant,0.2
    baseDivisionRate,5.67e-13
    divisionRateExponents,2.7
    maxMembraneAngle,1.047
    maxJunctionAngleConstant,0.6
```

## A7 Example pointlike cell specific parameter file

``` {.matlab language="Matlab"}
fMembrane,0.005
    fEdgeCell,0.0005
    focalAdhesionBreakingForce,1e-8
```

## A8 Example opto cell specific parameter file

``` {.matlab language="Matlab"}
fMembrane,0.0001
    fEdgeCell,0.0005
    maxMembraneAngle,1.047
    maxJunctionAngleConstant,0.6
    focalAdhesionBreakingForce,1e-8
```

## A9 Example stretch cell specific parameter file

``` {.matlab language="Matlab"}
fMembrane,0.0001
    fEdgeCell,0.0005
    maxMembraneAngle,1.047
    maxJunctionAngleConstant,0.6
    focalAdhesionBreakingForce,1e-8
```

## A10 Example stiffness gradient information file

The file must be a .csv file with three columns and at least two lines.
The leftmost column defined the positions in y-direction (in $\mu$m) in
relation to center of the substrate, and the middle column is used to
define the stiffness at those corresponding distances. The position
values must always be larger than on the previous line. The stiffness in
between positions are linearly interpolated and kept constant outside
the defined range. The first element of the third column gives an angle
that can be used to turn the gradient in relation to the y-direction (in
rad).

``` {.matlab language="Matlab"}
-50,1.1,0
    -30,11,0
```

## A11 Example stiffness heterogeneous information file

The file must be a .csv file with four values: the autocorrelation
length in x-direction, the autocorrelation length in y-direction, the
root mean square (RMS) height of the heterogeneity (defined how much the
stiffness can change as a function of position), and the angle (in rad)
that can be used to turn the heterogeneity landscape (e.g. if the
autocorrelation is required to affect in other directions than x or y.)

``` {.matlab language="Matlab"}
200,10,1,0
```

## A12 Example substrate parameter file

``` {.matlab language="Matlab"}
substratePointDistance,2e-6
    youngsModulus,1100
    youngsModulusConstant,7.62e-6
    restorativeForceConstant,2.9e-4
    repulsionLengthConstant,0.5
    honeycombConstants,114
    substrateEdgeConstant,100
```

## A13 Example focal adhesion parameter file

The file must be a .csv file with two columns: the left column defines
substrate stiffnesses (in Pa) and the right column the corresponding
focal adhesion strengths (in kg s^--2^ $\mu$m^--1^). The strengths for
the stiffness in between are linearly interpolated and for those that
are outside the specified range the closest value is used.

``` {.matlab language="Matlab"}
1100,0.0005
    4500,0.0008
    11000,0.0010
```

## A14 Example pointlike movement file

The file must be a .csv file with two columns: the left column defines
time points (in seconds) and the right column defined the amount of
movement of the pipette from the initial point (in $\mu$m). The movement
between the pipette positions is linear. The time values must always be
higher than on the previous line.

``` {.matlab language="Matlab"}
0,0
    1,30e-6
    10000,30e-6
```

## A15 Example opto activation file

The file must be a .csv file with two columns: the left column defines
time points (in seconds) where the activation changes, and the right
column defined the activation level (between 0 and 1) that is associated
with the time following the corresponding time point until the next time
point. The time values must always be higher than on the previous line.

``` {.matlab language="Matlab"}
0,0
    120,1
    1320,0
    2520,1
    3720,0
```

## A16 Example opto activation area file

The file must be a .csv file with two columns and at least three lines.
The left column defined the x-coordinates and the right column the
y-coordinates of the points used to defined activation area. If multiple
areas are activated, the set of coordinates should be separated by a
line of zeros (see example below).

``` {.matlab language="Matlab"}
0.14903,0.53511
    0.34207,0.56066
    0.37046,0.24271
    0.20297,0.20297
    0,0
    -0.17175,0.58053
    -0.032646,0.67137
    0.24555,0.22568
    0.075227,0.16323
```

## A17 Example stretch piecewise settings file

The file must be a .csv file with two columns and at least two lines.
The left column defined points in time (in seconds) and the right column
the substrate stretch associated with the time. The time values must
always be higher than on the previous line.

``` {.matlab language="Matlab"}
0,1.2
    1200,1
```

## A18 Example stretch sine settings file

The file must be a .csv file with three number: amplitude, frequency (in
Hz), phase (in rad).

``` {.matlab language="Matlab"}
0.5,0.001,0
```

## A19 Example export settings file

``` {.matlab language="Matlab"}
parameters,1
    vertices,1
    vertexStates,1
    division,1
    cellStates,1
    junctions,1
    boundaryLengths,0
    areas,0
    perimeters,0
    normProperties,1
    corticalStrengths,1
    lineage,1
    pointlike,0
    opto,0
    stretch,0
    substratePlot,0
    substrateFull,0
    cellForcesArea,0
    cellForcesCortical,0
    cellForcesJunctions,0
    cellForcesDivision,0
    cellForcesMembrane,0
    cellForcesFocalAdhesions,0
    cellForcesPointlike,0
    cellForcesContact,0
    cellForcesTotal,0
    substrateForcesCentral,0
    substrateForcesRepulsion,0
    substrateForcesRestoration,0
    substrateForcesFocalAdhesions,0
    substrateForcesTotal,0
```
