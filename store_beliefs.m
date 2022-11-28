%Get belief space B
beliefs_filename = '../problems/gouldian/beliefs_gouldian4_more.txt';
[B] = parse_beliefs_file(beliefs_filename);
[B_clean] = clean_beliefs(B);
save('../problems/gouldian/beliefs_gouldian4.mat', 'B_clean');