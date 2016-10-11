run('./toolbox/vl_setup.m');
dirp = './DataR/';
r = 5;
n = 256;
odirp = './Outputs/out_file.sift';

maindir = dir([dirp, '*.mp4']);
outfile = fopen(odirp, 'w','n','UTF-8');

% video = VideoReader([dirp, maindir(1).name]);
% while hasFrame(video)
%     frame = readFrame(video);
%     BWv = single(rgb2gray(frame));
%     [f,d] = vl_sift(BWv);
%     for ki = 1:size(f,2)
%         x = f(1,ki);
%         y = f(2,ki);
%         scale = f(3,ki);
%         orientation = f(4,ki);
%         aset = d(:, ki);
%         fprintf(outfile, 'sift_vector = [x = %f, y = %f, scale = %f, orientation = %f, ', x, y, scale, orientation);
%         for kj = 1:size(aset)
%             fprintf(outfile, 'a%d = %d, ', kj, aset(kj));
%         end
%         fprintf(outfile, ']\n');
%     end
% end



for vi = 1 : length(maindir)
    ivi = length(maindir) - vi + 1;
    video = VideoReader([dirp, maindir(ivi).name]);
    fj = 0;
    fprintf('handling video %d.....\n', vi);
    while hasFrame(video)
        fj = fj + 1;
        frame = readFrame(video);
        BWv = single(rgb2gray(frame));
        wn = video.Width/r;
        hn = video.Height/r;
        for i = 1:r
            for j = 1:r
                sx = (i - 1) * hn + 1;
                sy = (j - 1) * wn + 1;
                ex = i * hn;
                ey = j * wn;
                cell = BWv(sx:ex, sy:ey);
                [f,d] = vl_sift(cell);
                l = (i - 1) * r + j;                
                for ki = 1:size(f,2)
                    if ki == 1
                        fprintf(outfile, '\n');
                    end
                    kx = f(1,ki);
                    ky = f(2,ki);
                    scale = f(3,ki);
                    orientation = f(4,ki);
                    aset = d(:, ki);
                    fprintf(outfile, '<i = %d; j = %d; l = %d;', vi, fj, l);
                    fprintf(outfile, 'sift_vector_%d = [x = %f, y = %f, scale = %f, orientation = %f, ', ki, kx, ky, scale, orientation);
                    for kj = 1:size(aset)
                        fprintf(outfile, 'a%d = %d, ', kj, aset(kj));
                    end
                    fprintf(outfile, ']\t>\n');
                end
            end
        end 
    end
end

fclose(outfile);
