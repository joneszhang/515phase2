dirp = './DataR/';
r = 5;
n = 256;
odirp = './Outputs/out_file.chst';

maindir = dir([dirp, '*.mp4']);
outfile = fopen(odirp, 'w','n','UTF-8');

for vi = 1 : length(maindir)
    ivi = length(maindir) - vi + 1;
    video = VideoReader([dirp, maindir(ivi).name]);
    fj = 0;
    fprintf('handling video %d.....\n', vi);
    while hasFrame(video)
        fj = fj + 1;
        frame = readFrame(video);
        BWv = rgb2gray(frame);
        wn = video.Width/r;
        hn = video.Height/r;
        for i = 1:r
            for j = 1:r
                sx = (i - 1) * hn + 1;
                sy = (j - 1) * wn + 1;
                ex = i * hn;
                ey = j * wn;
                cell = BWv(sx:ex, sy:ey);
                h = imhist(cell, n);
                l = (i - 1) * r + j;
                fprintf(outfile, '<i = %d; j = %d; l = %d; ', vi, fj, l);
                fprintf(outfile, 'hisogram = [');
                fprintf(outfile, '%d ', h(:,1));
                fprintf(outfile,']\n');
            end
        end 
    end
end
fclose(outfile);
