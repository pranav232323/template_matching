function [FL, RL] = horizonatalSegmentation(imagen)
    % Remove empty borders
    imagen = clip(imagen);

    % Sum of pixel values across each row
    rowSum = sum(imagen, 2);
    threshold = 5;  % Adjust based on image resolution

    activeRows = rowSum > threshold;

    % Identify transitions (start and end of each line)
    transitions = diff([0; activeRows; 0]);
    starts = find(transitions == 1);
    ends = find(transitions == -1) - 1;

    if isempty(starts)
        FL = imagen;
        RL = [];
        return;
    end

    % Get first line
    FL = clip(imagen(starts(1):ends(1), :));

    % Get remaining part of image
    if length(starts) > 1
        RL = clip(imagen(starts(2):end, :));
    else
        RL = [];
    end
end
