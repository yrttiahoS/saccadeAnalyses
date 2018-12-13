function DATA = makeTETTimeCol(DATA, secondsCol, microsecsCol, timeCol)
%synopsis [stimcol] = makeTETTimeCol(filename, DATA, stimCodes, stimCNum, trialCNum)
%output:
%dataOut = all data

%input:
%DATA = all gazedata
%secondsCol = column number for TimeStampSeconds (Tobii gazedata)
%microsecsCol = coulumn number for TimeStampsMicroseconds (Tobii gazedata)
%timeCol = coulumn number for TETTime (Tobii gazedata)

s = DATA{1,secondsCol};
u = DATA{1,microsecsCol};

%calculate millisecond "TETTime" from timestamps
tettime = (double(s) + (double(u) / 10^6)) * 1000;

DATA{1, timeCol} = tettime;
    
    
end
