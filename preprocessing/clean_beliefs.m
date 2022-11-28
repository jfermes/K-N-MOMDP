function [beliefs] = clean_beliefs(beliefs)


%Given a set of beliefs, it removes repetitions and those beliefs that are
%equal given a tolerance


beliefs = unique(beliefs, 'rows', 'sorted');



end