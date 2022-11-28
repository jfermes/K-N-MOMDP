function [beliefs] = parse_beliefs_file(filename)

beliefs = readmatrix(filename);
beliefs(:,size(beliefs,2)) = [];


end