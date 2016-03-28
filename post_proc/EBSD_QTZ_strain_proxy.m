%% Post-processing Script
%--------------------------------------------------------------------------------------------------
clear
close all
clc

addpath('~/project/source/dev/');
setup_env

%{ 
===================================================================================================
Analysing ouputs from the following batch job scripts;

/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/batch_runs/EBSD_QTZ_strain_proxy/EBSD_QTZ_strain_proxy.sh

Which output to directories;

/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/J/EBSD_QTZ_strain_proxy.out
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Cont/EBSD_QTZ_strain_proxy.out
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Disc/EBSD_QTZ_strain_proxy.out

In order to analyse the indices relationship with strain
===================================================================================================
%}

% add paths to data locations
addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/J/EBSD_QTZ_strain_proxy.out')
addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Cont/EBSD_QTZ_strain_proxy.out')
addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Disc/EBSD_QTZ_strain_proxy.out')

% available pole figures
pfigs = [1,2,4,5,6,7,9];
indices = {'j','mc','md'};
   
for i = 1:length(pfigs)

    fname = sprintf('EBSD_QTZ_j_n5000_STR_%i_sd1.out',pfigs(i));
    EBSD_j(i) = read_texout(fname);
    
    J_STR(i,1) = get_strain(fname,'axial-compression');
    J_STR(i,2) = get_strain(fname,'simple-shear');
    
    fname = sprintf('EBSD_QTZ_mc_n5000_STR_%i_sd1.out',pfigs(i));
    EBSD_mc(i) = read_texout(fname);
    
    MC_STR(i,1) = get_strain(fname,'axial-compression');
    MC_STR(i,2) = get_strain(fname,'simple-shear');
    
    fname = sprintf('EBSD_QTZ_md_n5000_STR_%i_sd1.out',pfigs(i));
    EBSD_md(i) = read_texout(fname);
    
    MD_STR(i,1) = get_strain(fname,'axial-compression');
    MD_STR(i,2) = get_strain(fname,'simple-shear');

end

%% Create plots
fig = figure('Name','Pole fig analysis');

% set figure constants
%--------------------------------------------------------------------
    lwidth = 1.7;       % width of lines
     msize = 2;       % size of markers
     tsize = 13;      % text size for labels (e.g. x axis)
         w = 'bold';  % font weight
        lw = 'bold';  % weight of subplot letters
JY_Lim = [1 4];   % limit of J y-axis for axial compression
MY_Lim = [0 0.15]; % limif of M y-axis for axial compression


 lshift(1) = 0.28;    % values to shift legend
 lshift(2) = -0.14;

%--------------------------------------------------------------------

AX = subplot(1,2,1);

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(pfigs,EBSD_j,pfigs,EBSD_mc,'plot');

% add MD to correct axes
set(fig,'CurrentAxes',AX(2))
hold on
MD = plot(pfigs,EBSD_md);


% labels for this subplot,'Marker','o' 
ylabel(AX(1),'J-index','FontWeight',w,'FontSize',tsize)
ylabel(AX(2),'M-index','FontWeight',w,'FontSize',tsize)
xlabel(AX(1),'Pole figure no.','FontWeight',w,'FontSize',tsize)
%text(0.03,0.95*MY_AXC_Lim(2),'a)','FontWeight',w,'FontSize',tsize)

% format axes
xmin = min(pfigs);
xmax = max(pfigs);
set(AX,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax]) 
set(AX(1),'Box','off','YLim',JY_Lim,'YTick',[1 2.5 4]) % set const limits
set(AX(2),'Box','off','YLim',MY_Lim,'YTick',[0 0.075 0.15],'XAxisLocation','top') % set const limits

% format lines
c = 'k'; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

legh = legend([J,MC,MD],{'J-index','Cont. M-index','Disc. M-index'},'location','northwest');
set(legh,'Box','off')


% ============================= STRAIN ===============================
AX = subplot(1,2,2);

JY_Lim = [0 1.2];   % change limits to be appropriate for strain

% plot j and mc using plotyy to get both axes
[AX,J,MC] = plotyy(pfigs,J_STR(:,2),pfigs,MC_STR(:,2),'plot');

% add MD to correct axes
set(fig,'CurrentAxes',AX(2))
hold on
MD = plot(pfigs,MD_STR(:,2));


% labels for this subplot,'Marker','o' 
ylabel(AX(2),'Strain','FontWeight',w,'FontSize',tsize)
xlabel(AX(1),'Pole figure no.','FontWeight',w,'FontSize',tsize)
%text(0.03,0.95*MY_AXC_Lim(2),'a)','FontWeight',w,'FontSize',tsize)

% format axes
xmin = min(pfigs);
xmax = max(pfigs);
set(AX,'YColor','k','FontSize',tsize - 2,'FontWeight',w,...
    'XLim',[xmin xmax]) 
set(AX(1),'Box','off','YLim',JY_Lim,'YTick',[]) % set const limits
set(AX(2),'Box','off','YLim',JY_Lim,'YTick',[0 0.6 1.2],'XAxisLocation','top') % set const limits

% format lines
c = 'k'; % color for olivine
set(J,'LineStyle','-','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MC,'LineStyle',':','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)
set(MD,'LineStyle','--','LineWidth',lwidth,'MarkerSize',msize,'Color',c,'MarkerFaceColor',c)

%==========================================================================
% print to file
set(fig,'PaperType','a4','Units','centimeters',...
    'PaperOrientation','landscape','Position',[0 0 23.9 8.6],'PaperPositionMode','auto')
print('~/project/doc/final/figs/EBSD_ind-strain.pdf','-painters','-dpdf','-r800')




