celoc_Nimages = getappdata(0,'celoc_Nimages');
celoc_Ncells = getappdata(0,'celoc_Ncells');
celoc_area_list = getappdata(0,'celoc_area_list');
celoc_cell_tot = getappdata(0,'celoc_cell_tot');

% intialize area list
final_area_list = zeros(celoc_cell_tot,1);

% initialize cell counter
prev_cell_count = 0;

% loop over images
for i = 1:celoc_Nimages
    
    % loop over cells in image
    for j = 1:celoc_Ncells{i}
        
        % compile area list
        final_area_list(j+prev_cell_count) = celoc_area_list{i}(j);
        
    end
    
    % add previous cells to count
    prev_cell_count = prev_cell_count+celoc_Ncells{i};
    
end
