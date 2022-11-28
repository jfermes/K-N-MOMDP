function [filecondition] = print_reduced_policy(attributes, alphaVectorValues, reducedPolicy, belief_size, number_full_obs_var, filename)
%Takes the attributes (action, obsVal), the list of alpha vectors and a
%reduced policy and print everything into a .policy file





fid = fopen(filename, 'w+');


xml_header = '<?xml version="1.0" encoding="ISO-8859-1"?>';
version = '<Policy version="0.1" type="value" model="amodel.pomdpx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="policyx.xsd">';
alpha_header = strcat('<AlphaVector vectorLength="', num2str(belief_size), '" numObsValue="', num2str(number_full_obs_var), '" numVectors="', num2str(length(reducedPolicy)), '">');

fprintf(fid, '%s\n', xml_header);
fprintf(fid, '%s\n', version);
fprintf(fid, '%s\n', alpha_header);


for v = 1:length(reducedPolicy)
    
    vector = strcat('<Vector action="', num2str(attributes(reducedPolicy(v),1)), '" obsValue="', num2str(attributes(reducedPolicy(v),2)), '">');
    alpha_vector = strcat(vector, num2str(alphaVectorValues(reducedPolicy(v),:)), ' </Vector>');
    fprintf(fid, '%s\n', alpha_vector);

end


xml_end = '</AlphaVector> </Policy>';
fprintf(fid, '%s\n', xml_end);
fclose(fid);



end