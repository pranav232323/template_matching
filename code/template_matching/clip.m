function image_out = clip(image_in)
    [r, c] = find(image_in);
    if isempty(r) || isempty(c)
        image_out = zeros(1);  % or: image_out = []; to return empty
    else
        image_out = image_in(min(r):max(r), min(c):max(c));
    end
end
