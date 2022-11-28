K = [2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,45,50,55,60,65,70,75,100];

LB = [-10.66, -9.09, -5.25, -5.3, -5.18, -2.19, -0.62, -0.69, -0.69, -0.63, -0.62, -0.62, -0.622, -0.62, -0.62, -0.62, -0.62, -0.62,-0.62,-0.62,-0.62,-0.62,-0.621987];


            figure;
            plot(K, LB, 'r-o', 'LineWidth', 1)
            xlabel('K')
            ylabel('LB');
            title('Release of biocontrol agents K-MOMDP');
            legend('\phi_{a^*_d} $K$-MOMDP');
            plot_name_fig = strcat('figures/biocontrol-K-MOMDP.fig');
            plot_name_png = strcat('figures/biocontrol-K-MOMDP.png');
            saveas(gcf, plot_name_fig);
            saveas(gcf, plot_name_png);
            