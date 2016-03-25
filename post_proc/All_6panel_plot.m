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
addpath('~/project/analysis/outputs/M_Disc/all_6panel_plot.out/temp')
addpath('~/project/analysis/outputs/J/all_6panel_plot.out')

indices = {'j','mc','md'};

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
for i = 1:length(indices) 
    fname   = sprintf('QTZ_SPS_%s_n5000_strAll_sd1.out',indices{i}); 
    extract = read_texout(fname);
    
    QTZ_SPS(:,i+1) = extract(:,2);   
end
QTZ_SPS(:,1) = extract(:,1); % exctract strain for this panel

% -------------------------POST-PEROVSKITE ----------------------------

% pps axial compression
for i = 1:length(indices) 
    fname   = sprintf('PPS_AXC_%s_n5000_strAll_sd1.out',indices{i});
    extract = read_texout(fname);
    
    PPS_AXC(:,i+1) = extract(:,2);   
end
PPS_AXC(:,1) = extract(:,1); % exctract strain for this panel

% pps simple shear
for i = 1:length(indices) 
    fname   = sprintf('PPS_SPS_%s_n5000_strAll_sd1.out',indices{i}); 
    extract = read_texout(fname);
    
    PPS_SPS(:,i+1) = extract(:,2);   
end
PPS_SPS(:,1) = extract(:,1); % exctract strain for this panel


%======================================================================
%% Create plot

% set figure constants
%--------------------------------------------------------------------
    lwidth = 1.7;       % width of lines
     msize = 2;       % size of markers
     tsize = 13;      % text size for labels (e.g. x axis)
         w = 'bold';  % font weight
        lw = 'bold';  % weight of subplot letters
JY_AXC_Lim = [1 4];   % limit of J y-axis for axial compression
MY_AXC_Lim = [0 0.2]; % limif of M y-axis for axial compression
JY_SPS_Lim = [1 25];  % limit of J y-axis for axial compression
MY_SPS_Lim = [0 0.52]; % limif of M y-axis for axial compression

 lshift(1) = 0.28;    % values to shift legend
 lshift(2) = -0.14;

%--------------------------------------------------------------------

fig = figure('Name','Indices vs. strain');

% -------------------------- OLV AXC --------------------------------
AX  = subplot(3,2,1);
pos = get(AX,'pos');     % get the current axes position

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(OLV_AXC(:,1),OLV_AXC(:,2),OLV_AXC(:,1),OLV_AXC(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
hold on
MD = plot(OLV_AXC(:,1),OLV_AXC(:,4));


% labels for this subplot,'Marker','o'
title('Axial compression','FontWeight',w,'FontSize',tsize) 
ylabel(AX(1),'J-index','FontWeight',w,'FontSize',tsize)
text(0.03,0.95*MY_AXC_Lim(2),'a)','FontWeight',w,'FontSize',tsize)

% format axes
xmin = OLV_AXC(1,1);
xmax = OLV_AXC(length(OLV_AXC),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax]) 
set(AX(1),'Box','off','YLim',JY_AXC_Lim,'YTick',[1 2 3 4]) % set const limits
set(AX(2),'Box','off','YLim',MY_AXC_Lim,'YTick',[0 0.1 0.2],'XAxisLocation','top') % set const limits

% format lines
c = [0.2 0.6 0.2]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

legh = legend([J,MC,MD],{'J-index (olivine)','Cont. M-index (olivine)','Disc. M-index (olivine)'},'location','south');
lpos = get(legh,'pos');
set(legh,'Orientation','horizontal','Box','off','Position',[(lpos(1)+lshift(1)) ...
                                                           (lpos(2)+lshift(2)) ...
                                                            lpos(3) ...
                                                            lpos(4)])

% -------------------------- OLV SPS --------------------------------
AX  = subplot(3,2,2);
pos = get(AX,'pos');     % get the current axes position


% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(OLV_SPS(:,1),OLV_SPS(:,2),OLV_SPS(:,1),OLV_SPS(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
hold on
MD = plot(OLV_SPS(:,1),OLV_SPS(:,4));

% labels for this subplot
title({'Simple shear';''},'FontWeight',w,'FontSize',tsize) 
ylabel(AX(2),'M-index','FontWeight',w,'FontSize',tsize)
text(0.15,0.95*MY_SPS_Lim(2),'b)','FontWeight',w,'FontSize',tsize)

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
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)


% -------------------------- QTZ AXC --------------------------------
AX  = subplot(3,2,3);
pos = get(AX,'pos');     % get the current axes position
hold on

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(QTZ_AXC(:,1),QTZ_AXC(:,2),QTZ_AXC(:,1),QTZ_AXC(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
hold on
MD = plot(QTZ_AXC(:,1),QTZ_AXC(:,4));

% labels for this subplot
ylabel(AX(1),'J-index','FontWeight',w,'FontSize',tsize)
text(0.03,0.95*MY_AXC_Lim(2),'c)','FontWeight',w,'FontSize',tsize)

% format axes
xmin = QTZ_AXC(1,1);
xmax = QTZ_AXC(length(QTZ_AXC),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax]) 
set(AX(1),'YLim',JY_AXC_Lim,'Box','off','YTick',[1 2 3 4]) % set const limits
set(AX(2),'YLim',MY_AXC_Lim,'YTick',[0 0.1 0.2]) % set const limits

% format lines
c = [0.3 0.3 0.3]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

legh = legend([J,MC,MD],{'J-index (quartz)','Cont. M-index (quartz)','Disc. M-index (quartz)'},'location','south');
lpos = get(legh,'pos');
set(legh,'Orientation','horizontal','Box','off','Position',[(lpos(1)+lshift(1)) ...
                                                           (lpos(2)+lshift(2)) ...
                                                            lpos(3) ...
                                                            lpos(4)])


% -------------------------- QTZ SPS --------------------------------
AX  = subplot(3,2,4);
pos = get(AX,'pos');     % get the current axes position
hold on

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(QTZ_SPS(:,1),QTZ_SPS(:,2),QTZ_SPS(:,1),QTZ_SPS(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
hold on
MD = plot(QTZ_SPS(:,1),QTZ_SPS(:,4));

% labels for this subplot
ylabel(AX(2),'M-index','FontWeight',w,'FontSize',tsize)
text(0.15,0.95*MY_SPS_Lim(2),'d)','FontWeight',w,'FontSize',tsize)

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
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)


% -------------------------- PPS AXC --------------------------------
AX  = subplot(3,2,5);
pos = get(AX,'pos');     % get the current axes position

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(PPS_AXC(:,1),PPS_AXC(:,2),PPS_AXC(:,1),PPS_AXC(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
hold on
MD = plot(PPS_AXC(:,1),PPS_AXC(:,4));


% labels for this subplot
ylabel(AX(1),'J-index','FontWeight',w,'FontSize',tsize)
xlabel(AX(1),'Strain','FontWeight',w,'FontSize',tsize)
text(0.03,0.95*MY_AXC_Lim(2),'e)','FontWeight',w,'FontSize',tsize)

% format axes
xmin = PPS_AXC(1,1);
xmax = PPS_AXC(length(PPS_AXC),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax]) 
set(AX(1),'Box','off','YLim',JY_AXC_Lim,'YTick',[1 2 3 4]) % set const limits
set(AX(2),'Box','off','YLim',MY_AXC_Lim,'YTick',[0 0.1 0.2],'XAxisLocation','top') % set const limits

% format lines
c = [0.7 0.2 0.7]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

lshift(1) = 0.27;
lshift(2) = -0.16;

legh = legend([J,MC,MD],{'J-index (P-PS)','Cont. M-index (P-PS)','Disc. M-index (P-PS)'},'location','south');
lpos = get(legh,'pos');
set(legh,'Orientation','horizontal','Box','off','Position',[(lpos(1)+lshift(1)) ...
                                                           (lpos(2)+lshift(2)) ...
                                                            lpos(3) ...
                                                            lpos(4)])


% -------------------------- PPS SPS --------------------------------
AX  = subplot(3,2,6);
pos = get(AX,'pos');     % get the current axes position
hold on

% change of axis limits for final plot 
JY_AXC_Lim = [1 4];   % limit of J y-axis for axial compression
MY_AXC_Lim = [0 0.2]; % limif of M y-axis for axial compression
JY_SPS_Lim = [1 90];  % limit of J y-axis for axial compression
MY_SPS_Lim = [0 1]; % limif of M y-axis for axial compression


% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(PPS_SPS(:,1),PPS_SPS(:,2),PPS_SPS(:,1),PPS_SPS(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
hold on
MD = plot(PPS_SPS(:,1),PPS_SPS(:,4));

% labels for this subplot
ylabel(AX(2),'M-index','FontWeight',w,'FontSize',tsize)
xlabel(AX(1),'Strain','FontWeight',w,'FontSize',tsize)
text(0.15,0.95*MY_SPS_Lim(2),'f)','FontWeight',w,'FontSize',tsize)
text(1.6,0.07*MY_SPS_Lim(2),'\it{N.B. change of scale}','FontSize',tsize-2,...
          'Interpreter','tex')

% format axes
xmin = PPS_SPS(1,1);
xmax = PPS_SPS(length(PPS_SPS),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax])
set(AX(1),'YLim',JY_SPS_Lim,'YTick',[1 30 60 90],'Box','off') % set const limits
set(AX(2),'YLim',MY_SPS_Lim,'YTick',[0 0.5 1]) % set const limits

% set y limits
% ymax(1) = max(QTZ_SPS(:,2));
% ymax(1) = ymax(1) + 0.05*ymax(1);
% ymax(2) = max(QTZ_SPS(:,3));
% ymax(2) = ymax(2) + 0.05*ymax(2);
% set(AX(1),'YLim',[0 ymax(1)]);
% set(AX(2),'YLim',[0 ymax(2)]);

% format lines
%c = [0.3 0.3 0.3]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
                                                        
                                                        
%======================================================================
% print to pdf file
set(fig(1),'PaperType','a4','Units','centimeters','Position',[0 0 20.9 40.2],'PaperPositionMode','auto')
print('~/project/doc/final/figs/ALL_6panel_plot.pdf','-painters','-dpdf','-r800')


%% Second plot - Zoom on QTZ strain 
%======================================================================

clear QTZ_SPS
% quartz simple shear
for i = 1:length(indices) 
    fname   = sprintf('QTZ_SPS_%s_n5000_strAll_sd1_FULL.out',indices{i}); 
    extract = read_texout(fname);
    
    QTZ_SPS(:,i+1) = extract(:,2);   
end
QTZ_SPS(:,1) = extract(:,1); % exctract strain for this panel


fig = figure('Name','Quartz zoom')

% change of axis limits for new plot 
JY_AXC_Lim = [1 2];   % limit of J y-axis for axial compression
MY_AXC_Lim = [0 0.08]; % limif of M y-axis for axial compression
JY_SPS_Lim = [1 2];  % limit of J y-axis for axial compression
MY_SPS_Lim = [0 0.08]; % limif of M y-axis for axial compression

% -------------------------- QTZ AXC --------------------------------
AX  = subplot(1,2,1);
pos = get(AX,'pos');     % get the current axes position
hold on

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(QTZ_AXC(:,1),QTZ_AXC(:,2),QTZ_AXC(:,1),QTZ_AXC(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
hold on
MD = plot(QTZ_AXC(:,1),QTZ_AXC(:,4));

% labels for this subplot
%title({'Axial compression';''},'FontWeight',w,'FontSize',tsize)
ylabel(AX(1),'J-index','FontWeight',w,'FontSize',tsize)
xlabel(AX(1),'Strain','FontWeight',w,'FontSize',tsize)
text(0.03,0.95*MY_AXC_Lim(2),'a)         Axial compression','FontWeight',w,'FontSize',tsize)

% format axes
xmin = QTZ_AXC(1,1);
xmax = QTZ_AXC(length(QTZ_AXC),1);
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax]) 
set(AX(1),'YLim',JY_AXC_Lim,'Box','off','YTick',[1 1.5 2]) % set const limits
set(AX(2),'YLim',MY_AXC_Lim,'YTick',[0 0.04 0.08]) % set const limits

% format lines
c = [0.3 0.3 0.3]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

lshift(1) = 0.27;
lshift(2) = 0.79;

legh = legend([J,MC,MD],{'J-index (quartz)','Cont. M-index (quartz)','Disc. M-index (quartz)'},'location','south');
lpos = get(legh,'pos');
set(legh,'Orientation','horizontal','Box','off','Position',[(lpos(1)+lshift(1)) ...
                                                           (lpos(2)+lshift(2)) ...
                                                            lpos(3) ...
                                                            lpos(4)])


% -------------------------- QTZ SPS --------------------------------
AX  = subplot(1,2,2);
pos = get(AX,'pos');     % get the current axes position
hold on

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(QTZ_SPS(:,1),QTZ_SPS(:,2),QTZ_SPS(:,1),QTZ_SPS(:,3),'plot');

% add MD to correct axes
set(fig(1),'CurrentAxes',AX(2))
hold on
MD = plot(QTZ_SPS(:,1),QTZ_SPS(:,4));

% labels for this subplot
%title({'Simple shear';''},'FontWeight',w,'FontSize',tsize)
ylabel(AX(2),'M-index','FontWeight',w,'FontSize',tsize)
xlabel(AX(1),'Strain','FontWeight',w,'FontSize',tsize)
text(0.045,0.95*MY_SPS_Lim(2),'b)             Simple shear','FontWeight',w,'FontSize',tsize)

% format axes
xmin = QTZ_SPS(1,1);
xmax = 0.5;
set(AX,'Pos',pos,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax])
set(AX(1),'YLim',JY_SPS_Lim,'YTick',[1 1.5 2],'Box','off') % set const limits
set(AX(2),'YLim',MY_SPS_Lim,'YTick',[0 0.04 0.08]) % set const limits


% set y limits
% ymax(1) = max(QTZ_SPS(:,2));
% ymax(1) = ymax(1) + 0.05*ymax(1);
% ymax(2) = max(QTZ_SPS(:,3));
% ymax(2) = ymax(2) + 0.05*ymax(2);
% set(AX(1),'YLim',[0 ymax(1)]);
% set(AX(2),'YLim',[0 ymax(2)]);

% format lines
c = [0.3 0.3 0.3]; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

%======================================================================
% print to pdf file
set(fig(1),'PaperType','a4','Units','centimeters','Position',[0 20 22.9 8.6],'PaperPositionMode','auto')
print('~/project/doc/final/figs/QTZ_Strain_Zoom.pdf','-painters','-dpdf','-r800')

