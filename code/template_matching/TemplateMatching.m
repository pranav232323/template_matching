
function [letter, bestScore] = TemplateMatching(imgChar, templates, num_letters)
    C = zeros(1, num_letters);
    for n = 1:num_letters
        C(n) = corr2(templates{1, n}, imgChar);
    end

    [bestScore, vd] = max(C);
    charMap = ['A':'Z', '1':'9', '0', 'a':'z'];

    if vd > 0 && vd <= length(charMap) && bestScore > 0.5
        letter = charMap(vd);
    else
        letter = '?';
    end
end
