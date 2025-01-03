function plt_overlay_groundwater(O,years2plot,fig_title,unit,yname_upper_plt,bound_type)

%% NOTE: Years to plot are HYDROLOGICAL YEARS not CALANDER YEARS
clear bnds
hold on

        bnds_obs(:,:,1) = [O.rt.AY_median-O.rt.Q10,...
            O.rt.Q90-O.rt.AY_median];
        bnds_obs(:,:,2) = [O.rt.AY_median-O.rt.Q25,...
            O.rt.Q75-O.rt.AY_median];
        
        [hl, hp]  = boundedline(datenum(O.rt.Time)',...
            [O.rt.AY_median,O.rt.AY_median]',...
            bnds_obs,'alpha');
        
        hm = plot(datenum(O.rt.Time),O.rt.AY_median,'k','LineWidth',...
            1.5,'Displayname','Miðgildi athugana');
        
        ref_title = 'Mæld grunnvatnshæð';


% viðmiðunarár til að teikna með 
Legend=cell(3+length(years2plot),1);
Legend{1} = '10/90%';
Legend{2} = '25/75%';
Legend{3} = 'Miðgildi';

if isempty(years2plot) 
    
else
    cmap = lines(length(years2plot)+1);
    cmap(2,:) = []; 

    for i = 1:length(years2plot)
        
        if years2plot(i) == 2024 % setja sem gildandi vatnsár 
                
                Exist_Column = strcmp('HY_2024',O.rt.Properties.VariableNames); % Fiff til að laga þar sem vantar gögn fyrir vatnsárið og þá er HY_2024 ekki til    
                val = Exist_Column(Exist_Column==1); % Fiff til að laga þar sem vantar gögn fyrir vatnsárið og þá er HY_2024 ekki til            
            if isempty(val)
                continue
            else
            
            hy(i) = plot(datenum(O.rt.Time),O.rt.(...
            string(['HY_',num2str(years2plot(i))])),...
            'r','LineWidth',1.5,...
            'Displayname',num2str(years2plot(i)));

            end

        else
            hy(i) = plot(datenum(O.rt.Time),O.rt.(...
            string(['HY_',num2str(years2plot(i))])),...
            'Color',cmap(i,:),'LineWidth',1.3,...
            'Displayname',num2str(years2plot(i))); 
        end
        
        appy = num2str(years2plot(i)+1);
        Legend{3+i}=[num2str(years2plot(i)),'-',appy(3:4)];
        
    end
end

%legend(Legend)
%
vline(datenum(O.tbl.Time(end)),'--k','HandleVisibility','off');


    legend([hp(1:2);hm;hy'],Legend,'Location','southoutside',...
        'Orientation','horizontal');
    

%legend(Legend)
title(fig_title);
ylabel([yname_upper_plt,' ',unit]);
datetick('x','dd.mm');
grid on
%grid minor

text(0.01,0.96,['Nýjustu gögn: ',datestr(O.tbl.Time(end))],...
    'Units','normalized','HorizontalAlignment','left',...
    'VerticalAlignment','bottom','FontSize',12,'FontWeight','bold',...
    'Interpreter','none');

text(0.01,0.92,['Uppfært: ',datestr(now,'dd.mm.yyyy')],...
    'Units','normalized','HorizontalAlignment','left',...
    'VerticalAlignment','bottom','FontSize',12,'FontWeight','bold',...
    'Interpreter','none');

text(1,0.96,['Viðmið: ',ref_title, ' (',num2str(O.baseline_period(1).Year),' - ',num2str(O.baseline_period(2).Year),')'],...
    'Units','normalized','HorizontalAlignment','right',...
    'VerticalAlignment','bottom','FontSize',12,'FontWeight','bold',...
    'Interpreter','none');

ax = gca;
xtickangle(45);
set(gca,'TickDir','out');
set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'on'      , ...
    'YMinorTick'  , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'LineWidth'   , 1         );

set(gcf, 'Color', 'w');
set(gca,'FontSize',14);

end