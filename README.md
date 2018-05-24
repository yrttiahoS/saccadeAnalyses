# saccadeAnalyses
Code used for extracting saccade-based measures from eye tracking data.

Repository contains a script for saccade latency (i.e., gaze disengagement) analyses, called diseOO.m (fors disegagement and object-oriented). This script uses classes/objects that represent different aspects of parameterization for reading and analysing eye tracking data.

The classes use gazeAnalysisLib1_07_4b, which is library of eye tracking -related functions.
Classes:
Gazefile      - loading gazedata
HeadersET     - eye tracking variables / headers
ParamsET      - parameters for saccade extraction
SRTAnalyst2b  - saccade algorithm

Script / classes are compatible with a fixed ("standardized") format of eye tracking data. 
Standarization has been conducted using repository: https://github.com/yrttiahoS/py_gazedat
Format specifications can be queried with object.mehthods:
headers =                      HeadersET(); 
column_names =                 headers.hds.keys()';
column_positions_and_formats = headers.hds.values()';


