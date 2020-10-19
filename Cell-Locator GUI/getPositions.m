%Reads the metadata of the input .czi file and outputs an array
% containing the center positions of each tile
function [posList] = getPositions(pathname, filename, ext)
if strcmp(ext, '.czi') == 1
    data = czifinfo([pathname filename], 'P2');
    positions = extractAfter(data.metadataXML, '<SingleTileRegions>') ;
    positions = extractBefore(positions, '</SingleTileRegions>');
    zPositions = extractAfter(data.metadataXML, '<TimelineTrack Name="FocusActions Track"');
    zPositions = extractAfter(zPositions, '<TimelineElements>');
    zPositions = extractBefore(zPositions, '</TimelineElements>');
    numTiles = count(positions, '</SingleTileRegion>');
    posList = zeros(numTiles, 3);
    prevZPos = str2double(getPos(positions, '<Z>','</Z>'));
    interp_z = false;

    %Extract positions
    for i=1:numTiles
        xPos = getPos(positions,'<X>','</X>');
        posList(i, 1) = str2double(xPos);
        yPos = getPos(positions, '<Y>', '</Y>');
        posList(i, 2) = str2double(yPos);
        
        %Check if z-position was update by autofocus during acquisition
        zPosNum = extractAfter(zPositions, '<Bounds');
        zPosNum = extractAfter(zPosNum, 'StartS="');
        zPosNum = extractBefore(zPosNum, '"');
        zPosNum = str2num(zPosNum);
        if zPosNum + 1 == i
            checkZPos = extractAfter(zPositions, '<Result>');
            checkZPos = extractBefore(checkZPos, '</Result>');
            %If successfull autofocus, take the new focus position as
            %position otherwise use the starting position for autofocussing
            %as z-position
            if strcmp(checkZPos, 'Success') == 1
                zPos = getPos(zPositions, '<ResultPosition>', '</ResultPosition>');
                prevZPos = str2double(zPos);
                posList(i, 3) = str2double(zPos);
            else
                zPos = getPos(zPositions, '<StartPosition>', '</StartPosition>');
                prevZPos = str2double(zPos);
                posList(i,3) = prevZPos;
            end
            zPositions = extractAfter(zPositions, '</TimelineElement>');
            %If z-position was not update during acquisition, check if support
            %points were used, and if yes, interpolated the z-position of the
            %tile from the support point z-positions
            interp_z = false;
        else
            %Get the tile z-position
            posList(i,3) = prevZPos;
            prevZPos = str2double(getPos(positions, '<Z>','</Z>'));
            interp_z = true;
        end
        positions = extractAfter(positions, '</SingleTileRegion>');
    end
    
    if interp_z
        
        %check if support points were used with a global Focus surface
        %strategy
        af_strat = extractAfter(data.metadataXML, '<FocusStrategy IsActivated="');
        af_strat = extractBefore(af_strat, '">');
        if af_strat
            strat_m = extractAfter(data.metadataXML, '<StrategyMode>');
            strat_m = extractBefore(strat_m, '</StrategyMode>');
            if strat_m == 'GlobalFocusSurface'
              
                SPposXYZ = getSupportpoints(pathname, filename, ext);
%                 if size(SPposXYZ,1) >10
%                     model = 'poly33';
                if size(SPposXYZ,1) >5
                    model = 'poly22';
                elseif size(SPposXYZ,1) >2
                    model = 'poly11';
                else
                    model = 'poly00';
                end
                  fitsurface=fit(SPposXYZ(:,1:2),SPposXYZ(:,3), model,'Robust','Bisquare');
                posList(:,3) = fitsurface(posList(:,1),posList(:,2));
                figure(10)
                plot3(SPposXYZ(:,1),SPposXYZ(:,2),SPposXYZ(:,3),'ro')
                hold on
                plot(fitsurface)
                hold on
                plot3(posList(:,1),posList(:,2),posList(:,3),'go')
                
%                 %Interpolate the cell z-position from a linear interpolation of the
%                 %support point z-position
%                 av_gel_z = mean(SPposXYZ(:,3));
%                 %pad the array CHANGE TO IMAGE SIZE/2
%                 max_tile_x = max(SPposXYZ(:,1))+2000;
%                 min_tile_x = min(SPposXYZ(:,1))-2000;
%                 max_tile_y = max(SPposXYZ(:,2))+2000;
%                 min_tile_y = min(SPposXYZ(:,2))-2000;
%                 SPposXYZ = [SPposXYZ;[min_tile_x, min_tile_y av_gel_z];[max_tile_x min_tile_y av_gel_z];[min_tile_x max_tile_y av_gel_z];[max_tile_x max_tile_y av_gel_z]];
%                 %Define interpolation grid
%                 x=linspace(min_tile_x,max_tile_x,50);
%                 y=linspace(min_tile_y,max_tile_y,50);
%                 [X, Y] = meshgrid(x,y);
%                 %Interpolate the tile z-position on the grid
%                 itrp_surf = griddata(SPposXYZ(:,1),SPposXYZ(:,2),SPposXYZ(:,3),X,Y,'cubic');
%                 %Interpolate the cell z-position on the interpolated hydrogel surface
%                 posList(:,3) = griddata(X,Y,itrp_surf,posList(:,1),posList(:,2),'cubic')
            end
        end
    end
    
    
elseif ext == '.csv'
    data = readtable(filename, 'HeaderLines', 1);
    data = table2array(data);
    sz = size(data);
    posList = zeros(sz(1),3);
    for i = 1:sz(1)
        posList(i, 1) = data(i,2);
        posList(i, 2) = data(i,3);
        posList(i, 3) = data(i,4);
    end
end
end

function [pos] = getPos(positions, startPart, endPart)
pos = extractAfter(positions, startPart);
pos = extractBefore(pos, endPart);
end
