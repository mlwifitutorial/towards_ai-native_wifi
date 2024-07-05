%%% ***********************************************************************
%%% *                                                                     *
%%% *                AI-Native Wi-Fi (Magazine paper)                     *
%%% *                                                                     *
%%% * Submission to ...                                                   *
%%% *                                                                     *
%%% * Authors:                                                            *
%%% *   - Francesc Wilhelmi (francisco.wilhelmi@nokia.com)                *
%%% *   - Katarzyna Kosek-Szott                                           *
%%% *   - Szymon Szott                                                    *
%%% *   - Boris Bellalta                                                  *
%%% *                                                                     *
%%% * Copyright (C) 2024-2029, and GNU GPLd, by Francesc Wilhelmi         *
%%% *                                                                     *
%%% * Repository:                                                         *
%%% *  https://github.com/...                                             *
%%% ***********************************************************************

clear
clc

set(0, 'defaultTextInterpreter', 'latex');

% Komondor output file names
komondor_output_filenames = {'script_output_aiml_magazine_obsspd_-82', ...
                             'script_output_aiml_magazine_agents_obsspd', ...
                             'script_output_aiml_magazine_agents_obsspd_coordinated', ...
                             'script_output_aiml_magazine_agents_free', ...                             
                             'script_output_aiml_magazine_agents_free_coordinated'};

%% Load the data from the Komondor output files

for o = 1 : length(komondor_output_filenames)
    fid = fopen(['./Komondor_output/' komondor_output_filenames{o} '.txt'], 'rb');
    strings = textscan(fid, '%s', 'Delimiter', ';');
    fclose(fid);
    % Read and process the results line by line
    throughput{o} = [];
    airtime{o} = [];
    s_airtime{o} = [];
    packets_sent_lost{o} = [];
    rtscts_sent_lost{o} = [];
    nav_time{o} = [];
    waiting_time{o} = [];
    average_delay{o} = [];
    last_throughput{o} = [];
    last_average_delay{o} = [];
    last_sairtime{o} = [];
    last_airtime{o} = [];
    last_average_access_delay{o} = [];
    
    for i = 1 : length(strings{1})   
        disp(strings{1}(i))
        switch mod(i,13)
            case 1 % Header text
                %disp(strings{1}(i))
            case 2 % Throughput
                throughput_aux = strings{1}(i);
                throughput_unsplit = erase(throughput_aux{1},["{","}"]);
                throughput{o} = [throughput{o}; str2double(strsplit(throughput_unsplit, ','))];      
            case 3 % Successful airtime                  
                s_airtime_aux = strings{1}(i);
                s_airtime_unsplit = erase(s_airtime_aux{1},["{","}"]);
                s_airtime{o} = [s_airtime{o}; str2double(strsplit(s_airtime_unsplit, ','))];    
            case 4 % Total airtime
                airtime_aux = strings{1}(i);
                airtime_unsplit = erase(airtime_aux{1},["{","}"]);
                airtime{o} = [airtime{o}; str2double(strsplit(airtime_unsplit, ','))];   
            case 5 % Packets sent/lost ratio
                packets_sent_lost_aux = strings{1}(i);
                packets_sent_lost_unsplit = erase(packets_sent_lost_aux{1},["{","}"]);
                packets_sent_lost{o} = [packets_sent_lost{o}; str2double(strsplit(packets_sent_lost_unsplit, ','))];     
            case 6 % RTS/CTS sent/lost ratio
                rtscts_sent_lost_aux = strings{1}(i);
                rtscts_sent_lost_unsplit = erase(rtscts_sent_lost_aux{1},["{","}"]);
                rtscts_sent_lost{o} = [rtscts_sent_lost{o}; str2double(strsplit(rtscts_sent_lost_unsplit, ','))];     
            case 7 % Time in NAV
                nav_time_aux = strings{1}(i);
                nav_time_unsplit = erase(nav_time_aux{1},["{","}"]);
                nav_time{o} = [nav_time{o}; str2double(strsplit(nav_time_unsplit, ','))];     
            case 8 % Average delay
                average_delay_aux = strings{1}(i);
                average_delay_unsplit = erase(average_delay_aux{1},["{","}"]);
                average_delay{o} = [average_delay{o}; str2double(strsplit(average_delay_unsplit, ','))];   
            case 9 % Last throughput
                last_throughput_aux = strings{1}(i);
                last_throughput_unsplit = erase(last_throughput_aux{1},["{","}"]);
                last_throughput{o} = [last_throughput{o}; str2double(strsplit(last_throughput_unsplit, ','))];     
            case 10 % Last average delay
                last_average_delay_aux = strings{1}(i);
                last_average_delay_unsplit = erase(last_average_delay_aux{1},["{","}"]);
                last_average_delay{o} = [last_average_delay{o}; str2double(strsplit(last_average_delay_unsplit, ','))];    
            case 11 % Last successful airtime
                average_sairtime_aux = strings{1}(i);
                average_sairtime_unsplit = erase(average_sairtime_aux{1},["{","}"]);
                last_sairtime{o} = [last_sairtime{o}; str2double(strsplit(average_sairtime_unsplit, ','))];   
            case 12 % Last airtime
                last_airtime_aux = strings{1}(i);
                last_airtime_unsplit = erase(last_airtime_aux{1},["{","}"]);
                last_airtime{o} = [last_airtime{o}; str2double(strsplit(last_airtime_unsplit, ','))];     
            case 0 % Last average access delay
                last_average_access_delay_aux = strings{1}(i);
                last_average_access_delay_unsplit = erase(last_average_access_delay_aux{1},["{","}"]);
                last_average_access_delay{o} = [last_average_access_delay{o}; str2double(strsplit(last_average_access_delay_unsplit, ','))];   
        end
    end
end

% %%
% fig = figure('pos',[450 400 500 350]);
% set(0,'defaultUicontrolFontName','Helvetica');
% set(0,'defaultUitableFontName','Helvetica');
% set(0,'defaultAxesFontName','Helvetica');
% set(0,'defaultTextFontName','Helvetica');
% set(0,'defaultUipanelFontName','Helvetica');
% 
% subplot(1,3,1)
% bar([mean(mean(throughput{1})) mean(mean(throughput{2})) mean(mean(throughput{3})); ...
%     mean(min(throughput{1}')) mean(min(throughput{2}')) mean(min(throughput{3}')); ...
%     mean(max(throughput{1}')) mean(max(throughput{2}')) mean(max(throughput{3}'))])
% ylabel('Throughput (Mbps)')
% xticklabels({'Mean', 'Min', 'Max'})
% grid on
% grid minor
% set(gca, 'FontSize', 14)
% 
% subplot(1,3,2)
% bar([mean(mean(average_delay{1})) mean(mean(average_delay{2})) mean(mean(average_delay{3})); ...
%     mean(min(average_delay{1}')) mean(min(average_delay{2}')) mean(min(average_delay{3}')); ...
%     mean(max(average_delay{1}')) mean(max(average_delay{2}')) mean(max(average_delay{3}'))])
% ylabel('Av. delay (s)')
% xticklabels({'Mean', 'Min', 'Max'})
% grid on
% grid minor
% set(gca, 'FontSize', 14)
% % legend({'DCF', 'Static 11ax SR', 'Agent-based 11ax SR', 'Agent-based Free'})
% 
% subplot(1,3,3)
% bar([mean(mean(airtime{1})) mean(mean(airtime{2})) mean(mean(airtime{3})); ...
%     mean(min(airtime{1}')) mean(min(airtime{2}')) mean(min(airtime{3}')); ...
%     mean(max(airtime{1}')) mean(max(airtime{2}')) mean(max(airtime{3}'))])
% ylabel('Airtime (%)')
% xticklabels({'Mean', 'Min', 'Max'})
% grid on
% grid minor
% set(gca, 'FontSize', 14)
% legend({'DCF', 'Static 11ax SR', 'Agent-based 11ax SR', 'Agent-based Free'})

%% Plot bar plot (AVERAGE PERFORMANCE)
fig = figure('pos',[450 400 500 350]);
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

for o = 1 : length(komondor_output_filenames)
    average_delay{o}(average_delay{o}<0) = [];
end

subplot(1,5,1)
bar([mean(mean(throughput{1})) mean(mean(throughput{2})) mean(mean(throughput{3})) mean(mean(throughput{4})) mean(mean(throughput{5})); ...
    mean(min(throughput{1}')) mean(min(throughput{2}')) mean(min(throughput{3}')) mean(min(throughput{4}')) mean(min(throughput{5}')); ...
    mean(max(throughput{1}')) mean(max(throughput{2}')) mean(max(throughput{3}')) mean(max(throughput{4}')) mean(max(throughput{5}'))])
ylabel('Throughput (Mbps)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

subplot(1,5,2)
bar([mean(mean(average_delay{1})) mean(mean(average_delay{2})) mean(mean(average_delay{3})) mean(mean(average_delay{4})) mean(mean(average_delay{5})); ...
    mean(min(average_delay{1}')) mean(min(average_delay{2}')) mean(min(average_delay{3}')) mean(min(average_delay{4}')) mean(min(average_delay{5}')); ...
    mean(max(average_delay{1}')) mean(max(average_delay{2}')) mean(max(average_delay{3}')) mean(max(average_delay{4}')) mean(max(average_delay{5}'))])
ylabel('Av. delay (ms)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

subplot(1,5,3)
bar([mean(mean(airtime{1})) mean(mean(airtime{2})) mean(mean(airtime{3})) mean(mean(airtime{4})) mean(mean(airtime{5})); ...
    mean(min(airtime{1}')) mean(min(airtime{2}')) mean(min(airtime{3}')) mean(min(airtime{4}')) mean(min(airtime{5}')); ...
    mean(max(airtime{1}')) mean(max(airtime{2}')) mean(max(airtime{3}')) mean(max(airtime{4}')) mean(max(airtime{5}'))])
ylabel('Airtime (\%)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

subplot(1,5,4)
bar(100.*(1-[mean(mean(packets_sent_lost{1})) mean(mean(packets_sent_lost{2})) mean(mean(packets_sent_lost{3})) mean(mean(packets_sent_lost{4})) mean(mean(packets_sent_lost{5})); ...
    mean(max(packets_sent_lost{1}')) mean(max(packets_sent_lost{2}')) mean(max(packets_sent_lost{3}')) mean(max(packets_sent_lost{4}')) mean(max(packets_sent_lost{5}')); ...
    mean(min(packets_sent_lost{1}')) mean(min(packets_sent_lost{2}')) mean(min(packets_sent_lost{3}')) mean(min(packets_sent_lost{4}')) mean(min(packets_sent_lost{5}'))]))
ylabel('Successful data transmissions (\%)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

subplot(1,5,5)
bar([mean(mean(nav_time{1})) mean(mean(nav_time{2})) mean(mean(nav_time{3})) mean(mean(nav_time{4})) mean(mean(nav_time{5})); ...
    mean(min(nav_time{1}')) mean(min(nav_time{2}')) mean(min(nav_time{3}')) mean(min(nav_time{4}')) mean(min(nav_time{5}')); ...
    mean(max(nav_time{1}')) mean(max(nav_time{2}')) mean(max(nav_time{3}')) mean(max(nav_time{4}')) mean(max(nav_time{5}'))])
ylabel('Time in NAV (\%)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

% subplot(2,2,4)
% bar([mean(mean(s_airtime{1})) mean(mean(s_airtime{2})) mean(mean(s_airtime{3})) mean(mean(s_airtime{4})) mean(mean(s_airtime{5})); ...
%     mean(min(s_airtime{1}')) mean(min(s_airtime{2}')) mean(min(s_airtime{3}')) mean(min(s_airtime{4}')) mean(min(s_airtime{5}')); ...
%     mean(max(s_airtime{1}')) mean(max(s_airtime{2}')) mean(max(s_airtime{3}')) mean(max(s_airtime{4}')) mean(max(s_airtime{5}'))])
% ylabel('S Airtime (%)', 'Interpreter', 'latex')
% xticklabels({'Mean', 'Min', 'Max'})
% grid on
% grid minor
% set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')
legend({'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'}, 'Interpreter', 'latex')

%% Plot bar plot (LAST PERFORMANCE)
fig = figure('pos',[450 400 500 350]);
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

for o = 1 : length(komondor_output_filenames)
    last_average_delay{o}(last_average_delay{o}<0) = [];
    last_average_access_delay{o}(last_average_access_delay{o}<0) = [];
    last_average_access_delay{o}(isnan(last_average_access_delay{o})) = [];
end

subplot(1,5,1)
bar([mean(mean(last_throughput{1})) mean(mean(last_throughput{2})) mean(mean(last_throughput{3})) mean(mean(last_throughput{4})) mean(mean(last_throughput{5})); ...
    mean(min(last_throughput{1}')) mean(min(last_throughput{2}')) mean(min(last_throughput{3}')) mean(min(last_throughput{4}')) mean(min(last_throughput{5}')); ...
    mean(max(last_throughput{1}')) mean(max(last_throughput{2}')) mean(max(last_throughput{3}')) mean(max(last_throughput{4}')) mean(max(last_throughput{5}'))])
ylabel('Throughput (Mbps)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')
% legend({'DCF', 'Static 11ax SR', 'Agent-based 11ax SR', 'Agent-based Free'})

subplot(1,5,2)
bar([mean(mean(last_average_delay{1})) mean(mean(last_average_delay{2})) mean(mean(last_average_delay{3})) mean(mean(last_average_delay{4})) mean(mean(last_average_delay{5})); ...
    mean(min(last_average_delay{1}')) mean(min(last_average_delay{2}')) mean(min(last_average_delay{3}')) mean(min(last_average_delay{4}')) mean(min(last_average_delay{5}')); ...
    mean(max(last_average_delay{1}')) mean(max(last_average_delay{2}')) mean(max(last_average_delay{3}')) mean(max(last_average_delay{4}')) mean(max(last_average_delay{5}'))])
ylabel('Av. delay (ms)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

subplot(1,5,3)
bar([mean(mean(last_average_access_delay{1})) mean(mean(last_average_access_delay{2})) mean(mean(last_average_access_delay{3})) mean(mean(last_average_access_delay{4})) mean(mean(last_average_access_delay{5})); ...
    mean(min(last_average_access_delay{1}')) mean(min(last_average_access_delay{2}')) mean(min(last_average_access_delay{3}')) mean(min(last_average_access_delay{4}')) mean(min(last_average_access_delay{5}')); ...
    mean(max(last_average_access_delay{1}')) mean(max(last_average_access_delay{2}')) mean(max(last_average_access_delay{3}')) mean(max(last_average_access_delay{4}')) mean(max(last_average_access_delay{5}'))])
ylabel('Average access delay (ms)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

subplot(1,5,4)
bar([mean(mean(last_airtime{1})) mean(mean(last_airtime{2})) mean(mean(last_airtime{3})) mean(mean(last_airtime{4})) mean(mean(last_airtime{5})); ...
    mean(min(last_airtime{1}')) mean(min(last_airtime{2}')) mean(min(last_airtime{3}')) mean(min(last_airtime{4}')) mean(min(last_airtime{5}')); ...
    mean(max(last_airtime{1}')) mean(max(last_airtime{2}')) mean(max(last_airtime{3}')) mean(max(last_airtime{4}')) mean(max(last_airtime{5}'))])
ylabel('Airtime (\%)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

subplot(1,5,5)
bar([mean(mean(last_sairtime{1})) mean(mean(last_sairtime{2})) mean(mean(last_sairtime{3})) mean(mean(last_sairtime{4})) mean(mean(last_sairtime{5})); ...
    mean(min(last_sairtime{1}')) mean(min(last_sairtime{2}')) mean(min(last_sairtime{3}')) mean(min(last_sairtime{4}')) mean(min(last_sairtime{5}')); ...
    mean(max(last_sairtime{1}')) mean(max(last_sairtime{2}')) mean(max(last_sairtime{3}')) mean(max(last_sairtime{4}')) mean(max(last_sairtime{5}'))])
ylabel('Successful airtime (\%)', 'Interpreter', 'latex')
xticklabels({'Mean', 'Min', 'Max'})
grid on
grid minor
set(gca,'FontSize', 14, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')

legend({'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'}, 'Interpreter', 'latex')


%% SPIDER PLOT
fig = figure;
for i = 1 : 5
    P{i} = [mean(mean(last_throughput{i})), mean(mean(last_average_access_delay{i})), mean(mean(last_airtime{i})), ...
     mean(min(last_throughput{i}')), mean(min(last_average_access_delay{i}')), mean(min(last_sairtime{i}')), ...
     mean(max(last_throughput{i}')), mean(max(last_average_access_delay{i}')), mean(max(last_sairtime{i}'))];
end
% P = [aggtpt(1,:)' meansat(1,:)' eff(1,:)']; % Static
% P2 = [aggtpt(2,:)' meansat(2,:)' eff(2,:)']; % Auction
% P3 = [aggtpt(3,:)' meansat(3,:)' eff(3,:)']; % Marketplace
s = spider_plot_class([P{1}; P{2}; P{3}; P{4}; P{5}]);
% Spider plot properties
s.LegendLabels = {'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'};
s.LegendHandle.FontSize = 15;
s.LegendHandle.NumColumns = 1;
s.LineStyle = {'-.',':','--',':','--'};
s.AxesInterval = 2;
s.FillOption = {'on', 'on', 'on', 'on', 'on'};
s.Color = [1, 0, 0; 0, 1, 0; 0, 1, 0; 0, 0, 1; 0, 0, 1];
s.FillTransparency = [0.2, 0.2, 0.1, 0.1, 0.1];
s.LineTransparency = [.5, .5, 1, 1, 1];
s.LineWidth = [1, 1, 2, 1, 2];
s.AxesLabels = {'Mean throughput (Mbps)', 'Mean delay (ms)', 'Mean airtime (%)', ...
    'Min throughput (Mbps)', 'Min delay (ms)', 'Min airtime (%)', ...
    'Max throughput (Mbps)', 'Max delay (ms)', 'Max airtime (%)'};
s.AxesFont = 'Times New Roman';
s.LabelFont = 'Times New Roman';
s.AxesFontSize = 14;
s.AxesLabelsEdge = 'none';
s.LabelFontSize = 16;
% s.LineWidth = 1;
% s.LineTransparency = .5;
s.MarkerSize = 1;
s.MarkerTransparency = .5;
s.AxesLimits = [0, 0, 0, 0, 0, 0, 0, 0, 0; ...
                110, 2400, 100, 110, 2400, 100, 110, 2400, 100];


%% SPIDER PLOT (Mean + selected percentile)
fig = figure;
prctile_val = 10;
for i = 1 : 5
    P{i} = [mean(mean(last_throughput{i})), mean(prctile(last_throughput{i}, 100-prctile_val)), ...
        mean(mean(last_average_access_delay{i})), mean(prctile(last_average_access_delay{i}, prctile_val)), ...
        mean(mean(last_airtime{i})), mean(prctile(last_airtime{i}, 100-prctile_val))];
end
% Create the spider plot
A = [P{1}; P{2}; P{3}; P{4}; P{5}];
s = spider_plot_class(A);
% Edit spider plot properties
s.LegendLabels = {'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'};
s.LegendHandle.FontSize = 12;
s.LegendHandle.NumColumns = 2;
s.LegendHandle.Interpreter = 'latex';
s.LineStyle = {'-',':','--',':','--'};
s.AxesInterval = 2;
s.FillOption = {'on', 'off', 'on', 'off', 'on'};
s.Color = [184,84,80; 108,142,191; 108,142,191; 130,179,102; 130,179,102]./255;
s.FillTransparency = [0.3, 0.2, 0.1, 0.1, 0.1];
s.LineTransparency = [.5, .5, 1, 1, 1];
s.LineWidth = [1.5, 1.5, 1.5, 1.5, 1.5];
s.AxesLabels = {'Mean throughput (Mbps)', sprintf('%dth percentile\nthroughput (Mbps)', 100-prctile_val), ...
    'Mean delay (ms)', sprintf('%dth percentile\ndelay (ms)', prctile_val), ...
    'Mean airtime (%)', sprintf('%dth percentile\nairtime (%%)', 100-prctile_val)};
s.AxesFont = 'Times New Roman';
s.LabelFont = 'Times New Roman';
s.AxesFontSize = 12;
s.AxesLabelsEdge = 'none';
s.LabelFontSize = 13;
% s.LineWidth = 1;
% s.LineTransparency = .5;
s.MarkerSize = 1;
s.MarkerTransparency = .5;
% s.AxesLimits = [0, 0, 0, 0, 0, 0; ...
%                 90, 90, 350, 350, 100, 100]; % for 5th
s.AxesLimits = [0, 0, 0, 0, 0, 0; ...
                120, 120, 90, 90, 100, 100]; % for 90th


%% SPIDER PLOT (Q1, Q2, Q3)
fig = figure;
for i = 1 : 5
    P{i} = [mean(prctile(last_throughput{i}, 25)), mean(prctile(last_throughput{i}, 50)), mean(prctile(last_throughput{i}, 75)) ...
        mean(prctile(last_average_access_delay{i}, 75)), mean(prctile(last_average_access_delay{i}, 50)), mean(prctile(last_average_access_delay{i}, 25))...
        mean(prctile(last_airtime{i}, 25)), mean(prctile(last_airtime{i}, 50)), mean(prctile(last_airtime{i}, 75))];
end
% Create the spider plot
A = [P{1}; P{2}; P{3}; P{4}; P{5}];
s = spider_plot_class(A);
% Edit spider plot properties
s.LegendLabels = {'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'};
s.LegendHandle.FontSize = 12;
s.LegendHandle.NumColumns = 2;
s.LegendHandle.Interpreter = 'latex';
%s.LineStyle = {'-',':','--',':','--'};
%s.AxesInterval = 2;
%s.FillOption = {'on', 'off', 'on', 'off', 'on'};
%s.Color = [184,84,80; 108,142,191; 108,142,191; 130,179,102; 130,179,102]./255;
%s.FillTransparency = [0.3, 0.2, 0.1, 0.1, 0.1];
%s.LineTransparency = [.5, .5, 1, 1, 1];
%s.LineWidth = [1.5, 1.5, 1.5, 1.5, 1.5];
%s.AxesLabels = {sprintf('Throughput\nreliability(Mbps)'), sprintf('Throughput\nmedian(Mbps)'), sprintf('Peak\nthroughput(Mbps)'), ...
%    sprintf('Zero-latency\nreliability (ms)'), sprintf('Zero-latency\nmedian (ms)'), sprintf('Peak\nZero-latency (ms)'), ...
%    sprintf('Airtime\nreliability (%%)'), sprintf('Airtime\nmedian (%%)'), sprintf('Peak\nairtime (%%)')};
s.LineStyle = {'-','-','--','-','--'};
s.AxesInterval = 2;
s.FillOption = {'on', 'on', 'on', 'on', 'off'};
s.Color = [253,231,37; 94, 201, 98; 94, 201, 98;68, 1, 84; 68, 1, 84]./255;
s.FillTransparency = [0.4, 0.05, 0.05, 0.05, 0.05];
s.LineTransparency = [1, 1, 1, 1, 1];
s.LineWidth = [1.25, 1.25, 1.25, 1.25, 1.25];
s.AxesLabels = {sprintf('Throughput\nreliability(Mbps)'), sprintf('Throughput\nmedian(Mbps)'), sprintf('Throughput\npeak(Mbps)'), ...
    sprintf('Zero-latency\nreliability (ms)'), sprintf('Zero-latency\nmedian (ms)'), sprintf('Peak\nZero-latency (ms)'), ...
    sprintf('Airtime\nreliability (%%)'), sprintf('Airtime\nmedian (%%)'), sprintf('Peak\nairtime (%%)')};
s.AxesFont = 'Times New Roman';
s.LabelFont = 'Times New Roman';
s.AxesFontSize = 12;
s.AxesLabelsEdge = 'none';
s.LabelFontSize = 13;
% Reverse the axes for the delay
s.AxesDirection{4} = 'reverse';
s.AxesDirection{5} = 'reverse';
s.AxesDirection{6} = 'reverse';
% s.LineWidth = 1;
% s.LineTransparency = .5;
s.MarkerSize = 1;
s.MarkerTransparency = .5;
s.AxesLimits = [0, 0, 0, 0, 0, 0, 0, 0, 0; ...
                110, 110, 110, 30, 2.5, 0.2, 100, 100, 100];

%% Plot CDFs
fig = figure('pos',[450 400 500 350]);
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

subplot(3,1,1)
for o = 1 : length(komondor_output_filenames)
    cdfplot(last_throughput{o}(:))
    hold on
end
xlabel('Throughput (Mbps)')
grid on
grid minor
set(gca, 'FontSize', 14)
% legend({'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'})

subplot(3,1,2)
for o = 1 : length(komondor_output_filenames)
    cdfplot(last_average_delay{o}(:))
    hold on
end
xlabel('Average delay (ms)')
grid on
grid minor
set(gca, 'FontSize', 14)
% legend({'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'})

subplot(3,1,3)
for o = 1 : length(komondor_output_filenames)
    cdfplot(last_average_access_delay{o}(:))
    hold on
end
xlabel('Average access delay (ms)')
grid on
grid minor
set(gca, 'FontSize', 14)
legend({'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'})
