function constants = get_honeycomb_constants(app)
% GET_HONEYCOMB_CONSTANTS Get honeycomb constants
%   The function calculates the honeycomb constant values (alpha, beta, and
%   gamma) from the give three digit number given in the parameters.
%   INPUT:
%       app: main application object
%   OUTPUT:
%       constants: honeycomb constants
%   by Aapo Tervonen, 2021


% get the honeycomb constant number
constants = app.substrateParameters.honeycombConstants;

% get the modulus of the number when dividing by 100
modulus = mod(constants, 100);

% alpha is the first digit (remove the previous modulus from the number and
% divide by 100 to obtain the full hundreds)
alpha = round((constants - modulus)/100);

% remove the hundreds from the number
constants = constants - alpha*100;

% get the modulus of the number when dividing by 10
modulus = mod(constants, 10);

% beta is the second digit (remove the previous modulus from the number and
% divide by 10 to obtain the full tens)
beta = round((constants - modulus)/10);

% gamma is the last digit
gamma = constants - beta*10;

% save the values
constants = [];
constants.alpha = alpha;
constants.beta = beta;
constants.gamma = gamma;

end