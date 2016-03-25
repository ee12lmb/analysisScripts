%% Post-processing Script
%--------------------------------------------------------------------------------------------------
clear
close all
clc

addpath('~/project/source/dev/');
setup_env;

%{
==================================================================================================
Analysing the results from the following batch job script:
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/batch_runs/OLV_AXC_bin_conv/MD_bin_conv_OLV_AXC_n2000_M_DISC_INTERP.sh

Which output to the following directory:
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Disc/MD_bin_conv_OLV_AXC_n2000_M_DISC_INTERP.out
==================================================================================================
%}

%% Add paths and read in data
addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Disc/MD_bin_conv_OLV_AXC_n2000_M_DISC_INTERP.out')

bins_cell = {'3';'2.75';'2.5';'2.25';'2';'1.75';'1.5';'1.25';'1';'0.75';'0.5';'0.25'};
bins = [3;2.75;2.5;2.25;2;1.75;1.5;1.25;1;0.75;0.5;0.25];
steps = [1;8;15;21];
strain = [0.02;0.16;0.3;0.42];

for i = 1:length(bins_cell)
    
    fname = sprintf('OLV_AXC_md_n2000_b%s_strAll_sd1.out',bins_cell{i});
    raw = read_texout(fname)
    md(:,i) = raw(:,2);
    
end
md;

% separate strain
%strain = raw(:,1);

% initialise arrays for plotting continuous m-index
mc = zeros(length(bins),4);

% load continuous M-index for reference
% addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/IR/MC_conv_OLV_AXC_n10000_run2.out')
% for i = 1:length(steps)
%     
%     fname = sprintf('OLV_AXC_mc_n2000_r50_st%i_sd1.out',steps(i));
%     mc_raw = read_texout(fname);
%     mc(:,i) = mean(mc_raw);
%       
% end

mc_raw = read_texout('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Cont/OLV_AXC_mc_n2000_strAll_4comp.out');
for i = 1:length(steps)
    for j = 1:length(bins)

        mc(j,i) = mc_raw(steps(i),2);

    end
end

%% Plot for relevant time steps
fig = 1;

% set figure constants
%--------------------------------------------------------------------
t_h     = 0.93;   % text height (precentage of max y)
lwidth  = 1.5;    % width of lines
msize   = 5;      % size of markers
labsize = 15;     % text size for labels (e.g. x axis)
itemx   = 5;      % subplot label x position (e.g. a) in top left)
itemy   = 0.06;   % scaling to how far up the y axes labels should be
w       = 'bold'; % font weight
lw      = 'bold';   % weight of subplot letters
%--------------------------------------------------------------------

% collect data into vector for plotting
fig = figure(fig);
mc;
for i = 1:length(steps)
    md(steps(i),:);
    AX = subplot(2,2,i);
    hold on
    H_MD = plot(bins,md(steps(i),:),'ok-');
    H_MC = plot(bins,mc(:,i),'--');
    AX.YLim = [0 0.12];
    
    set(AX,'XLim',[0.25 3],'XDir','reverse','FontSize',labsize - 2,'FontWeight',w)
    set(H_MD,'Marker','o','MarkerFaceColor','k','MarkerSize',msize,'LineWidth',lwidth)
    set(H_MC,'LineWidth',lwidth,'Color',[0.6 0.6 0.6])
    
    if     (i == 1)
        ylabel('M-index','FontSize',labsize,'FontWeight',w)
        text(2.97,0.06*0.12,'a)','FontSize',labsize,'FontWeight',w)
    elseif (i == 2)
        legend([H_MD H_MC],'Discrete M-index','Continuous M-index','location','northeast')
        legend boxoff
        text(2.97,0.06*0.12,'b)','FontSize',labsize,'FontWeight',w)
    elseif (i == 3)
        ylabel('M-index','FontSize',labsize,'FontWeight',w)
        xlabel('Bin size (\circ)','FontSize',labsize,'FontWeight',w)
        text(2.97,0.06*0.12,'c)','FontSize',labsize,'FontWeight',w)
    elseif (i == 4)
        xlabel('Bin size (\circ)','FontSize',labsize,'FontWeight',w)
        text(2.97,0.06*0.12,'d)','FontSize',labsize,'FontWeight',w)
    end
    
    title_str = sprintf('Strain = %i%%',strain(i)*100);
    title(title_str,'FontSize',labsize,'FontWeight',w)
    
end

%print to pdf file
set(fig(1),'PaperType','a4','Units','centimeters','PaperOrientation','landscape','Position',[0 0 29.7 21.0],'PaperPositionMode','auto')
print('~/project/doc/final/figs/OLV_AXC_bin_conv.pdf','-painters','-dpdf','-r800')


