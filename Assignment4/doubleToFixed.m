## -*- texinfo -*-
## @deftypefn {Function File} {} doubleToFixed (@var{inval})
## Converts inval from double to fixed point
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

## Author: BrettDutro

function outval = doubleToFixed (inval)

outval = uint16(0);

if(inval < 0)
    outval = bitset(outval,16,1);
end

outval = bitor(uint16(bitshift(uint16(uint8(floor(abs(inval)))),7)),outval);
fracpart = uint8(round(2^7*(abs(inval) - floor(abs(inval)))));

outval = bitor(outval,uint16(fracpart));

endfunction
