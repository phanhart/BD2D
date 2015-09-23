function [deltaRB, deltaRE, deltaD] = bd2d(RB1, RE1, D1, IB1, IE1, RB2, RE2, D2, IB2, IE2)
%Rate-Distortion Evaluation for Two-Layer Coding Systems
% Extension of the Bjontegaard model for two-layer coding systems based on
% the model proposed in
%
% Philippe Hanhart and Touradj Ebrahimi, "Rate-Distortion Evaluation for
% Two-Layer Coding Systems", IEEE International Conference on Image
% Processing (ICIP), Québec City, Canada, September 2015.
%
% Input parameters:
% - RB1: base layer bit rate values for codec A
% - RE1: enhancement layer bit rate values for codec A
% - D1: PSNR values for codec A
% - IB1: base layer parameter indexes for codec A
% - IE1: enhancement layer parameter indexes for codec A
% - RB2: base layer bit rate values for codec B
% - RE2: enhancement layer bit rate values for codec B
% - D2: PSNR values for codec B
% - IB2: base layer parameter indexes for codec B
% - IE2: enhancement layer parameter indexes for codec B
%
% RB, RE, D, IB, and IE must be vectors of the same length containing at
% least 16 values.
%
% IB and IE are indexes that helps identifying low and high bit rates.
% For example, if you use a set of 4 values for the parameter (PB) that 
% controls the base layer bit rate (RB) and 4 values for the parameter (PE)   
% that controls the enhancement layer bit rate (RE), then you will get a  
% total of 16  triplets (RB,RE,D). You must then identify which triplet 
% corresponds to which parameter: set IB to 1 when PB produces the lowest
% RB and set IB to 4 when PB produces the highest RB, while 2 and 3 are
% used used for the two other values of PB. The same principle applies for
% IE.
% Note that it is not necessary to set IB and IE in the range 1..M, but
% it should be proportional to the bit rate. For example, if you are using
% JPEG XT and playing with the base and enhancement layer parameters q and
% Q, respectively, you can simply set IB=q and IE=Q, as the bit rates are
% proportional to the quality parameters. If you are using a scalable video
% codec and playing with the quantization parameters of the base and
% enhancement layers, QPB and QPE, you can set IB=100-QPB and IE=100-QPE,
% as the bit rates are inversely proportional to the QP values.
%
% Output parameters:
% - deltaRB: average base layer bit rate difference
% - deltaRE: average enhancement layer bit rate difference
% - deltaD: average PSNR difference
%
% Author: Philippe Hanhart (philippe.hanhart@epfl.ch)
% Date: 2015/9/22

if all(size(RB1) > 1) || all(size(RE1) > 1) || all(size(D1) > 1) || all(size(IB1) > 1) || all(size(IE1) > 1) || all(size(RB2) > 1) || all(size(RE2) > 1) || all(size(D2) > 1) || all(size(IB2) > 1) || all(size(IE2) > 1)
error('RB, RE, D, IB, and IE must be vectors.\n');
end
if length(RB1) < 16 || length(RE1) < 16 || length(D1) < 16 || length(IB1) < 16 || length(IE1) < 16 || length(RB2) < 16 || length(RE2) < 16 || length(D2) < 16 || length(IB2) < 16 || length(IE2) < 16
error('At least 16 triplets are required for each R^2-D surface.\n');
end
if any(size(RB1)~=size(RE1)) || any(size(RB1)~=size(D1)) || any(size(RB1)~=size(IB1)) || any(size(RB1)~=size(IE1)) || any(size(RB2)~=size(RE2)) || any(size(RB2)~=size(D2)) || any(size(RB2)~=size(IB2)) || any(size(RB2)~=size(IE2))
error('RB, RE, D, IB, and IE must have the same size.\n');
end

A.rB = log10(RB1(:));
A.rE = log10(RE1(:));
A.D = D1(:);
A.IB = IB1(:);
A.IE = IE1(:);
B.rB = log10(RB2(:));
B.rE = log10(RE2(:));
B.D = D2(:);
B.IB = IB2(:);
B.IE = IE2(:);

deltaRB = computeDelta(A, B, 'base');
deltaRE = computeDelta(A, B, 'enhancement');
deltaD = computeDelta(A, B, 'PSNR');
