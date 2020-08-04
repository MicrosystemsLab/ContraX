%Reads the metadata of the input .czi file and outputs an array
% containing the center positions of each tile
function [SPposList] = getPositions(pathname, filename, ext)
if strcmp(ext, '.czi') == 1
    data = czifinfo([pathname filename], 'P2');
    positions = extractAfter(data.metadataXML, '<SupportPoints>') ;
    positions = extractBefore(positions, '</SupportPoints>');
    %zPositions = extractAfter(data.metadataXML, '<TimelineElements>');
    %zPositions = extractBefore(zPositions, '</TimelineElements>');
    numTiles = count(positions, '</SupportPoint>');
    SPposList = zeros(numTiles, 3);
    prevZPos = str2double(getPos(positions, '<Z>','</Z>'));
    for i=1:numTiles
        xPos = getPos(positions,'<X>','</X>');
        SPposList(i, 1) = str2double(xPos);
        yPos = getPos(positions, '<Y>', '</Y>');
        SPposList(i, 2) = str2double(yPos);
        %zPosNum = extractAfter(zPositions, '<Bounds StartS="');
        %zPosNum = extractBefore(zPosNum, '" StartB=');
        %zPosNum = str2num(zPosNum);
        SPposList(i,3) = prevZPos;
        prevZPos = str2double(getPos(positions, '<Z>','</Z>'));
        positions = extractAfter(positions, '</SupportPoint>');
    end
    
end
end

function [pos] = getPos(positions, startPart, endPart)
pos = extractAfter(positions, startPart);
pos = extractBefore(pos, endPart);
end

