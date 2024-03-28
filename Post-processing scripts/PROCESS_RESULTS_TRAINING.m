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

komondor_output_foldernames = {'dcf', ...
                            'agents_dec_11axSR', ...
                            'agents_coord_11axSR', ...
                            'agents_dec_free', ...
                            'agents_coord_free'};

% Komondor output file names
komondor_output_filenames = {'logs_output_TEST_AGENTS_A0_A', ...
                            'logs_output_TEST_AGENTS_A1_B', ...
                            'logs_output_TEST_AGENTS_A2_C', ...
                            'logs_output_TEST_AGENTS_A3_D'};

%% Load the data from the Komondor output files
for a = 1 : length(komondor_output_foldernames)
    for o = 1 : length(komondor_output_filenames)
        fid = fopen(['./Komondor_agents_output/' komondor_output_foldernames{a} '/' komondor_output_filenames{o} '.txt'], 'rb');
        strings = textscan(fid, '%s', 'Delimiter', ';');
        fclose(fid);
        % Read and process the results line by line
        action_ix{a,o} = [];
        throughput{a,o} = [];
        avg_delay{a,o} = [];
        max_delay{a,o} = [];
        min_delay{a,o} = [];
        reward{a,o} = [];
        for i = 1 : length(strings{1})   
            % Process the line depending on the 
            if contains(strings{1}(i), 'Action')
                reward_aux = strings{1}(i);
                str_split = strsplit(reward_aux{1}, ["(",")"]);
                action_ix{a,o} = [action_ix{a,o} str2num(str_split{2})];
            elseif contains(strings{1}(i), 'Average throughput')
                thorughput_aux = strings{1}(i);
                str_split = strsplit(thorughput_aux{1}, ["=","Mbps"]);
                throughput{a,o} = [throughput{a,o} str2num(str_split{2})];
            elseif contains(strings{1}(i), 'Average delay')
                avg_delay_aux = strings{1}(i);
                str_split = strsplit(avg_delay_aux{1}, ["=","s"]);
                avg_delay{a,o} = [avg_delay{a,o} str2num(str_split{2})];
            elseif contains(strings{1}(i), 'Maximum delay')
                max_delay_aux = strings{1}(i);
                str_split = strsplit(max_delay_aux{1}, ["=","s"]);
                max_delay{a,o} = [max_delay{a,o} str2num(str_split{2})];
            elseif contains(strings{1}(i), 'Minimum delay')
                min_delay_aux = strings{1}(i);
                str_split = strsplit(min_delay_aux{1}, ["=","s"]);
                min_delay{a,o} = [min_delay{a,o} str2num(str_split{2})];
            elseif contains(strings{1}(i), 'Associated reward')
                reward_aux = strings{1}(i);
                str_split = strsplit(reward_aux{1}, "=");
                reward{a,o} = [reward{a,o} str2num(str_split{2})];
            end        
        end
    end
end

%% Plot bar plot (AVERAGE PERFORMANCE - ONLY MEAN WITH STD)
fig = figure('pos',[450 400 500 350]);
colors = [184,84,80; 108,142,191; 108,142,191; 130,179,102; 130,179,102]./255;
for a = 2 : length(komondor_output_foldernames)
    subplot(2, 2, a-1)
    hold on
    mean_tpt = mean([throughput{a,1}; throughput{a,2}; throughput{a,3}; throughput{a,4}]);
    std_tpt = std([throughput{a,1}; throughput{a,2}; throughput{a,3}; throughput{a,4}]);
    x = 1:numel(mean_tpt);
    std_dev = 1;
    curve1 = mean_tpt + std_tpt;
    curve2 = mean_tpt - std_tpt;
    x2 = [x, fliplr(x)];
    inBetween = [curve1, fliplr(curve2)];
    %fill(x2, inBetween, colors(a,:), 'FaceAlpha', 0.2);
    hold on;
    plot(x, mean_tpt, 'color', colors(a,:), 'LineWidth', 1.5);
%     % DCF
%     plot(mean([throughput{1,1}; throughput{1,2}; throughput{1,3}; throughput{1,4}]), '--', 'LineWidth', 1.5)
    ylabel('Throughput (Mbps)', 'Interpreter', 'latex')
    xlabel('Time (s)')
    grid on
    grid minor
    set(gca,'FontSize', 12, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')
    title(komondor_output_foldernames{a})
end
% legend({'Mean throughput', 'Max throughput', 'Min throughput', 'Mean DCF', 'Max DCF', 'Min DCF'}, 'Interpreter','latex')

%% Plot bar plot (AVERAGE PERFORMANCE)
fig = figure('pos',[450 400 500 350]);
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

for a = 2 : length(komondor_output_foldernames)
    subplot(2, 2, a-1)
    hold on
    plot(mean([throughput{a,1}; throughput{a,2}; throughput{a,3}; throughput{a,4}]))
    plot(max([throughput{a,1}; throughput{a,2}; throughput{a,3}; throughput{a,4}]))
    plot(min([throughput{a,1}; throughput{a,2}; throughput{a,3}; throughput{a,4}]))
    % DCF
    plot(mean([throughput{1,1}; throughput{1,2}; throughput{1,3}; throughput{1,4}]), '--', 'LineWidth', 1.5)
    plot(max([throughput{1,1}; throughput{1,2}; throughput{1,3}; throughput{1,4}]), '--', 'LineWidth', 1.5)
    plot(min([throughput{1,1}; throughput{1,2}; throughput{1,3}; throughput{1,4}]), '--', 'LineWidth', 1.5)
    ylabel('Throughput (Mbps)', 'Interpreter', 'latex')
    xlabel('Time (s)')
    grid on
    grid minor
    set(gca,'FontSize', 12, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')
    title(komondor_output_foldernames{a})
end
legend({'Mean throughput', 'Max throughput', 'Min throughput', 'Mean DCF', 'Max DCF', 'Min DCF'}, 'Interpreter','latex')

%% Plot bar plot (SINGLE AP PERFORMANCE)
fig = figure('pos',[450 400 500 350]);
set(0,'defaultUicontrolFontName','Helvetica');
set(0,'defaultUitableFontName','Helvetica');
set(0,'defaultAxesFontName','Helvetica');
set(0,'defaultTextFontName','Helvetica');
set(0,'defaultUipanelFontName','Helvetica');

ap_ix = 1;
for a = 1 : length(komondor_output_foldernames)
    hold on
    if a == 1
        plot(throughput{a, ap_ix}, '--', 'LineWidth',2)
    else
        plot(throughput{a, ap_ix})
    end    
    ylabel('Throughput (Mbps)', 'Interpreter', 'latex')
    xlabel('Time (s)')
    grid on
    grid minor
    set(gca,'FontSize', 12, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')
    title(komondor_output_foldernames{a})
end
legend({'DCF', 'Agent/DEC 11axSR', 'Agent/COORD 11axSR', 'Agent/DEC Free', 'Agent/COORD Free'})


%% Plot bar plot (AVERAGE PERFORMANCE - ONLY AGGREGATE WITH STD)
fig = figure('pos',[450 400 500 350]);
colors = [184,84,80; 108,142,191; 108,142,191; 130,179,102; 130,179,102]./255;
subplot(1, 2, 1)
hold on
mean_tpt_11ax = mean([throughput{2,1}; throughput{2,2}; throughput{2,3}; throughput{2,4}]);
mean_tpt_free_dec = mean([throughput{4,1}; throughput{4,2}; throughput{4,3}; throughput{4,4}]);
mean_tpt_free_coord = mean([throughput{5,1}; throughput{5,2}; throughput{5,3}; throughput{5,4}]);
%     std_tpt = std([throughput{a,1}; throughput{a,2}; throughput{a,3}; throughput{a,4}]);
x = 1:numel(mean_tpt_11ax);
%     std_dev = 1;
%     curve1 = mean_tpt + std_tpt;
%     curve2 = mean_tpt - std_tpt;
%     x2 = [x, fliplr(x)];
%     inBetween = [curve1, fliplr(curve2)];
%     fill(x2, inBetween, colors(a,:), 'FaceAlpha', 0.2);
%     hold on;
plot(mean_tpt_11ax, 'color', colors(3,:), 'LineWidth', 1.5);
plot(mean_tpt_free_dec, 'color', colors(4,:), 'LineWidth', 1.5);
plot(mean([throughput{1,1}; throughput{1,2}; throughput{1,3}; throughput{1,4}]), '--', 'LineWidth', 1.5, 'Color', colors(1,:))
legend({'Agent/11axSR', 'Agent/Free', 'DCF'}, 'Interpreter','latex')
ylabel('Mean Throughput (Mbps)', 'Interpreter', 'latex')
xlabel('Time (s)')
grid on
grid minor
set(gca,'FontSize', 12, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')
title('Decentralized')

subplot(1, 2, 2)
hold on
min_tpt_11ax = min([throughput{3,1}; throughput{3,2}; throughput{3,3}; throughput{3,4}]);
min_tpt_free = min([throughput{5,1}; throughput{5,2}; throughput{5,3}; throughput{5,4}]);
plot(min_tpt_11ax, 'color', colors(3,:), 'LineWidth', 1.5);
plot(min_tpt_free, 'color', colors(4,:), 'LineWidth', 1.5);
plot(min([throughput{1,1}; throughput{1,2}; throughput{1,3}; throughput{1,4}]), '--', 'LineWidth', 1.5, 'Color', colors(1,:))
legend({'Agent/11axSR', 'Agent/Free', 'DCF'}, 'Interpreter','latex')
ylabel('Min. Throughput (Mbps)', 'Interpreter', 'latex')
xlabel('Time (s)')
grid on
grid minor
set(gca,'FontSize', 12, 'FontName', 'Times', 'TickLabelInterpreter', 'latex')
title('Coordinated')
% legend({'Mean throughput', 'Max throughput', 'Min throughput', 'Mean DCF', 'Max DCF', 'Min DCF'}, 'Interpreter','latex')