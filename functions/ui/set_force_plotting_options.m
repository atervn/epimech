function [pastOption] = set_force_plotting_options(app,pastOption)

if pastOption == 0
    
    switch app.ForceDropDown.Value
        case 'Total forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesTotal;
            app.CallingApp.importPlottingOptions.cellForcesTotal = true;
        case 'Cortical forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesCortical;
            app.CallingApp.importPlottingOptions.cellForcesCortical = true;
        case 'Junction forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesJunctions;
            app.CallingApp.importPlottingOptions.cellForcesJunctions = true;
        case 'Division forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesDivision;
            app.CallingApp.importPlottingOptions.cellForcesDivision = true;
        case 'Membrane forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesMembrane;
            app.CallingApp.importPlottingOptions.cellForcesMembrane = true;
        case 'Contact forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesContact;
            app.CallingApp.importPlottingOptions.cellForcesContact = true;
        case 'Area forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesArea;
            app.CallingApp.importPlottingOptions.cellForcesArea = true;
        case 'Pointlike forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesPointlike;
            app.CallingApp.importPlottingOptions.cellForcesPointlike = true;
        case 'Focal adhesion forces'
            pastOption = app.CallingApp.importPlottingOptions.cellForcesFocalAdhesions;
            app.CallingApp.importPlottingOptions.cellForcesFocalAdhesions = true;
        case 'Total substrate forces'
            pastOption = app.CallingApp.importPlottingOptions.substrateForcesTotal;
            app.CallingApp.importPlottingOptions.substrateForcesTotal = true;
        case 'Direct substrate forces'
            pastOption = app.CallingApp.importPlottingOptions.substrateForcesDirect;
            app.CallingApp.importPlottingOptions.substrateForcesDirect = true;
        case 'Restorative substrate forces'
            pastOption = app.CallingApp.importPlottingOptions.substrateForcesRepulsion;
            app.CallingApp.importPlottingOptions.substrateForcesRepulsion = true;
        case 'Repulsion substrate forces'
            pastOption = app.CallingApp.importPlottingOptions.substrateForcesRestoration;
            app.CallingApp.importPlottingOptions.substrateForcesRestoration = true;
        case 'Focal adhesion substrate forces'
            pastOption = app.CallingApp.importPlottingOptions.substrateForcesFocalAdhesions;
            app.CallingApp.importPlottingOptions.substrateForcesFocalAdhesions = true;
    end
    
else
    
    switch app.ForceDropDown.Value
        case 'Total forces'
            app.CallingApp.importPlottingOptions.cellForcesTotal = pastOption;
        case 'Cortical forces'
            app.CallingApp.importPlottingOptions.cellForcesCortical = pastOption;
        case 'Junction forces'
            app.CallingApp.importPlottingOptions.cellForcesJunctions = pastOption;
        case 'Division forces'
            app.CallingApp.importPlottingOptions.cellForcesDivision = pastOption;
        case 'Membrane forces'
            app.CallingApp.importPlottingOptions.cellForcesMembrane = pastOption;
        case 'Contact forces'
            app.CallingApp.importPlottingOptions.cellForcesContact = pastOption;
        case 'Area forces'
            app.CallingApp.importPlottingOptions.cellForcesArea = pastOption;
        case 'Pointlike forces'
            app.CallingApp.importPlottingOptions.cellForcesPointlike = pastOption;
        case 'Focal adhesion forces'
            app.CallingApp.importPlottingOptions.cellForcesFocalAdhesions = pastOption;
        case 'Total substrate forces'
            app.CallingApp.importPlottingOptions.substrateForcesTotal = pastOption;
        case 'Direct substrate forces'
            app.CallingApp.importPlottingOptions.substrateForcesTotal = pastOption;
        case 'Restorative substrate forces'
            app.CallingApp.importPlottingOptions.substrateForcesRepulsion = pastOption;
        case 'Repulsion substrate forces'
            app.CallingApp.importPlottingOptions.substrateForcesRestoration = pastOption;
        case 'Focal adhesion substrate forces'
            app.CallingApp.importPlottingOptions.substrateForcesFocalAdhesions = pastOption;
    end
    
end