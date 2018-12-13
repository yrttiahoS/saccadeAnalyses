function [index] = cumulativeSaccadePotential(dise_time, min_dise, max_dise)
% [index] = cumulativeSaccadePotential(dise_time, min_dise, max_dise)

index = 1 - ((max_dise - dise_time)/(max_dise - min_dise));