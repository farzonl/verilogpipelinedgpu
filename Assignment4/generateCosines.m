## -*- texinfo -*-
## @deftypefn {Function File} {} generateCosines ()
## Generates a cosine lookup table in 1.8.7 fixed point format.
##
## @example
## @group
## 
##      @result{} 
## @end group
## @end example
##
## @seealso{}
## @end deftypefn

## Author: Brett Dutro

function generateCosines ()

fid = fopen("cosine_LUT.v","w");
fprintf(fid,"//Returns cos(INVAL) where INVAL is in the range [-255,255] in 1.8.7 format\n\n");
fprintf(fid,"module cosine_LUT(INVAL,OUTVAL);\ninput[15:0] INVAL;\noutput[15:0] OUTVAL;\n\n//Round INVAL to the nearest degree\nwire[15:0] INVAL_rounded = (INVAL[15] == 1 && INVAL[7] == 1'b1) ? {INVAL[15:7] - 1'b1,7'b0} : (INVAL[15] == 0 && INVAL[7] == 1'b1) ? {INVAL[15:7] + 1'b1,7'b0} : {INVAL[15:7],7'b0};\n\nassign OUTVAL = ");
for x = 0:180
    res = cos(x*pi/180);
    res_fixed = doubleToFixed(res);
    if(x == 180)
        fprintf(fid,"(INVAL_rounded == 16'h%x || INVAL_rounded == 16'h%x) ? 16'h%x : 16'hXXXX;\n",doubleToFixed(x), doubleToFixed(-1*x), res_fixed);
    elseif(360 - x <= 255)
        fprintf(fid,"(INVAL_rounded == 16'h%x || INVAL_rounded == 16'h%x || INVAL_rounded == 16'h%x || INVAL_rounded == 16'h%x) ? 16'h%x : \n\t\t\t\t",doubleToFixed(x),doubleToFixed(-1*x),doubleToFixed(360 - x),doubleToFixed(-360 + x),res_fixed);
    else
        fprintf(fid,"(INVAL_rounded == 16'h%x || INVAL_rounded == 16'h%x) ? 16'h%x : \n\t\t\t\t",doubleToFixed(x),doubleToFixed(-1*x),res_fixed);
    end
end
fprintf(fid,"endmodule\n");
fclose(fid);
endfunction
