function template_matching

    %% Load and Show Image
    %imagen = imread("C:\Users\Pranav\OneDrive\Desktop\Matlab_docs\Rotork\template_matching\opt.png");
    cam = webcam("Mi USB Webcam HD");
    imagen = snapshot(cam);
    figure; imshow(imagen); title('Input Image with Noise');

    %% Convert to Grayscale and Preprocess
% This works for both RGB and grayscale images
imagen = im2gray(imagen);
imagen = imadjust(imagen);  % optional: boost contrast

% Use adaptive thresholding (for varying brightness)
imagen = imbinarize(imagen, 'adaptive', 'Sensitivity', 0.6);

% Invert only if digits appear white on black
imagen = imcomplement(imagen);  % Make digits white for OCR logic

% Clean borders and small objects
imagen = imclearborder(imagen);
imagen = bwareaopen(imagen, 20);

figure; imshow(imagen); title('Binary Image After Preprocessing');
fprintf('[INFO] Post-threshold pixels: %d\n', nnz(imagen));


    fprintf('[INFO] Preprocessing complete. Non-zero pixels: %d\n', nnz(imagen));

    %% Initialize
    RL = imagen;    % Remaining image to process line-by-line
    word = [];
    fid = fopen('text.txt', 'wt');

    load("C:\Users\Pranav\OneDrive\Desktop\Matlab_docs\Rotork\template_matching\templates.mat", "templates");
    num_letters = size(templates, 2);

    %% Horizontal Line Segmentation Loop
    while ~isempty(RL)
        fprintf('[INFO] Starting horizontal segmentation...\n');

        [FL, RL] = horizonatalSegmentation(RL);
        if isempty(FL)
            fprintf('[WARN] No line found. Exiting.\n');
            break;
        end

        figure(2); imshow(FL); title('Segmented Line');
        pause(0.5);

        n = 0;
        spacevector = [];
        RA = FL;

        %% Vertical Character Segmentation Loop
        [charImages, spacevector] = verticalSegmentation(FL);
        fprintf('[DEBUG] Number of characters segmented: %d\n', numel(charImages));
n = numel(charImages);
for i = 1:n
    imgChar = charImages{i};
    fprintf('[DEBUG] Char %d width: %d px\n', i, size(charImages{i}, 2));
    [letter, bestScore] = TemplateMatching(imgChar, templates, num_letters);
    figure(10); imshow(imgChar); title(['Char ', num2str(i)]); pause(0.5);
    fprintf('[DEBUG] Char %d: size = %dx%d | Best match: %s (%.3f)\n', ...
    i, size(imgChar,1), size(imgChar,2), letter, bestScore);
    word = [word letter];
    
end


% --- Insert spaces based on spacing vector ---
if ~isempty(spacevector)
    avg_space = mean(spacevector);
    fixed_threshold = 12;  % minimum pixels to consider as a "space"
    dynamic_factor = 1.5;  % 150% of average space = dynamic space

    max_threshold = max(fixed_threshold, dynamic_factor * avg_space);
    fprintf('[INFO] Dynamic space threshold: %.2f px\n', max_threshold);

    no_spaces = 0;

    for x = 1:n
        curr_space = spacevector(x + no_spaces);
        fprintf('[DEBUG] space[%d] = %d\n', x, curr_space);

        if curr_space > max_threshold
            no_spaces = no_spaces + 1;

            % Shift characters to make space
            for m = x:n
                word(n + x - m + no_spaces) = word(n + x - m + no_spaces - 1);
            end

            % Insert space
            word(x + no_spaces) = ' ';
            spacevector = [0 spacevector];
        end
    end
end

        fprintf(fid, '%s\n', word);  % Write recognized line
        fprintf('[INFO] Completed line: %s\n', word);
        word = [];
    end

    % fclose(fid);
    % fprintf('[INFO] Recognition complete. Opening result...\n');
    % winopen('text.txt');


end
