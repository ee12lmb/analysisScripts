%% Post-processing Script
%-------------------------------------------------------------------------
clear; close all; clc;

addpath('~/project/source/dev/');
setup_env

%{ 
===================================================================================================
Script plots six panel figure demonstrating how each index increase with
strain for olivine, quartz and post-perovskite in both axial compression
and simple shear regimes.

The script that created the data files is:
~/project/analysis/scripts/batch_runs/strain_proxy_6panel/ALL_AXC+SPS_n5000_strAll.sh

Which output data to the following locations:
~/project/analysis/outputs/M_Cont/all_6panel_plot.out
~/project/analysis/outputs/M_Disc/all_6panel_plot.out
~/project/analysis/outputs/J/all_6panel_plot.out
===================================================================================================
%}

%% Read in and separate data

% add paths to data locations
addpath('~/project/analysis/outputs/M_Cont/all_6panel_plot.out')
addpath('~/project/analysis/outputs/M_Disc/all_6panel_plot.out')
addpath('~/project/analysis/outputs/J/all_6panel_plot.out')

indices = {'j','mc'};

% ----------------------------------------------------------------------
% Data is loaded such that each panel has its own vector, with the 
% columns setup up as follows;
%
% strain | j | mc | md
%-----------------------------------------------------------------------

% -------------------------- OLIVINE -----------------------------------

% olivine axial compression
for i = 1:length(indices) 
    fname   = sprintf('OLV_AXC_%s_n5000_strAll_sd1.out',indices{i});
    extract = read_texout(fname);
    
    OLV_AXC(:,i+1) = extract(:,2);   
end
OLV_AXC(:,1) = extract(:,1); % exctract strain for this panel

% olivine simple shear
for i = 1:length(indices) % olivine axial compression
    fname   = sprintf('OLV_SPS_%s_n5000_strAll_sd1.out',indices{i}); 
    extract = read_texout(fname);
    
    OLV_SPS(:,i+1) = extract(:,2);   
end
OLV_SPS(:,1) = extract(:,1); % exctract strain for this panel


% -------------------------- QUARTZ -----------------------------------

% quartz axial compression
for i = 1:length(indices) 
    fname   = sprintf('QTZ_AXC_%s_n5000_strAll_sd1.out',indices{i});
    extract = read_texout(fname);
    
    QTZ_AXC(:,i+1) = extract(:,2);   
end
QTZ_AXC(:,1) = extract(:,1); % exctract strain for this panel

% quartz simple shear
for i = 1:length(indices) % olivine axial compression
    fname   = sprintf('QTZ_SPS_%s_n5000_strAll_sd1.out',indices{i}); 
    extract = read_texout(fname);
    
    QTZ_SPS(:,i+1) = extract(:,2);   
end
QTZ_SPS(:,1) = extract(:,1); % exctract strain for this panel


%======================================================================
%% Create plot

% set figure constants
%--------------------------------------------------------------------
    lwidth = 1;       % width of lines
     msize = 2;       % size of markers
     tsize = 13;      % text size for labels (e.g. x axis)
         w = 'bold';  % font weight
        lw = 'bold';  % weight of subplot letters
JY_AXC_Lim = [1 3];   % limit of J y-axis for axial compression
MY_AXC_Lim = [0 0.1]; % limif of M y-axis for axial compression
JY_SPS_Lim = [1 25];   % limit of J y-axis for axial compression
MY_SPS_Lim = [0 0.5]; % limif of M y-axis for axial compression

%--------------------------------------------------------------------

fig = figure('Name','Indices vs. strain');

% -------------------------- OLV AXC --------------------------------
AX  = subplot(3,2,1);
pos = get(AX,'pos');     % get the current axes position
hold on

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(OLV_AXC(:,1),OLV_AXC(:,2),OLV_AXC(:,1),OLV_AXC(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
%MD = plot(OLV_AXC(:,1),OLV_AXC(:,4));

% labels for this subplot
title('Axial compression','FontWeight',w,'FontSize',tsize) 
ylabel(AX(1),'J-index','FontWeight',w,'FontSize',tsize)
text(0.03,0.95*MY_AXC_Lim(2),'a)','FontWeight',w,'FontSize',tsize)

% format axes
xmin = OLV_AXC(1,1);
xmax = OLV_AXC(length(OLV_AXC),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax]) 
set(AX(1),'Box','off','YLim',JY_AXC_Lim) % set const limits
set(AX(2),'Box','off','YLim',MY_AXC_Lim,'XAxisLocation','top') % set const limits

% format lines
c = [0.2 0.6 0.2]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
%set(MD,'LineStyle','--','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

% -------------------------- OLV SPS --------------------------------
AX  = subplot(3,2,2);
pos = get(AX,'pos');     % get the current axes position
hold on

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(OLV_SPS(:,1),OLV_SPS(:,2),OLV_SPS(:,1),OLV_SPS(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
%MD = plot(OLV_AXC(:,1),OLV_AXC(:,4));

% labels for this subplot
title({'Simple shear';''},'FontWeight',w,'FontSize',tsize) 
ylabel(AX(2),'M-index','FontWeight',w,'FontSize',tsize)

% format axes
xmin = OLV_SPS(1,1);
xmax = OLV_SPS(length(OLV_SPS),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax])
set(AX(1),'YLim',JY_SPS_Lim,'Box','off','YTick',[1 13 25]) % set const limits
set(AX(2),'YLim',MY_SPS_Lim,'YTick',[0 0.25 0.5]) % set const limits

% set y limits
% ymax(1) = max(OLV_SPS(:,2));
% ymax(1) = ymax(1) + 0.05*ymax(1);
% ymax(2) = max(OLV_SPS(:,3));
% ymax(2) = ymax(2) + 0.05*ymax(2);
% set(AX(1),'YLim',[0 ymax(1)]);
% set(AX(2),'YLim',[0 ymax(2)]);

% format lines
c = [0.2 0.6 0.2]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
%set(MD,'LineStyle','--','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

% -------------------------- QTZ AXC --------------------------------
AX  = subplot(3,2,3);
pos = get(AX,'pos');     % get the current axes position
hold on

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(QTZ_AXC(:,1),QTZ_AXC(:,2),QTZ_AXC(:,1),QTZ_AXC(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
%MD = plot(OLV_AXC(:,1),OLV_AXC(:,4));

% labels for this subplot
ylabel(AX(1),'J-index','FontWeight',w,'FontSize',tsize)
text(0.03,0.95*MY_AXC_Lim(2),'c)','FontWeight',w,'FontSize',tsize)

% format axes
xmin = QTZ_AXC(1,1);
xmax = QTZ_AXC(length(QTZ_AXC),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax]) 
set(AX(1),'YLim',JY_AXC_Lim,'Box','off','YTick',[1 2 3]) % set const limits
set(AX(2),'YLim',MY_AXC_Lim) % set const limits

% format lines
c = [0.3 0.3 0.3]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
%set(MD,'LineStyle','--','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

% -------------------------- QTZ SPS --------------------------------
AX  = subplot(3,2,4);
pos = get(AX,'pos');     % get the current axes position
hold on

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(QTZ_SPS(:,1),QTZ_SPS(:,2),QTZ_SPS(:,1),QTZ_SPS(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
%MD = plot(OLV_AXC(:,1),OLV_AXC(:,4));

% labels for this subplot
ylabel(AX(2),'M-index','FontWeight',w,'FontSize',tsize)

% format axes
xmin = OLV_SPS(1,1);
xmax = OLV_SPS(length(OLV_SPS),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax])
set(AX(1),'YLim',JY_SPS_Lim,'YTick',[1 13 25],'Box','off') % set const limits
set(AX(2),'YLim',MY_SPS_Lim,'YTick',[0 0.25 0.5]) % set const limits

% set y limits
% ymax(1) = max(QTZ_SPS(:,2));
% ymax(1) = ymax(1) + 0.05*ymax(1);
% ymax(2) = max(QTZ_SPS(:,3));
% ymax(2) = ymax(2) + 0.05*ymax(2);
% set(AX(1),'YLim',[0 ymax(1)]);
% set(AX(2),'YLim',[0 ymax(2)]);

% format lines
c = [0.3 0.3 0.3]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth+0.5,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth+0.5,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
%set(MD,'LineStyle','--','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color',c,'MarkerFaceColor',c)




%======================================================================
% print to pdf file
set(fig(1),'PaperType','a4','Units','centimeters','Position',[0 0 20.9 40.2],'PaperPositionMode','auto')
print('~/project/doc/final/figs/ALL_6panel_plot.pdf','-painters','-dpdf','-r800')



