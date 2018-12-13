function [vector] = normalizeVector(vector)
%Function [vector] = normalizeVector(vector)
%
% Takes away the mean of the vector.

vector1 = vector;

% take away bad values (here, all above zero so -1 excluded)
vector1(vector1<0) = [];

vector = vector - mean(vector1);