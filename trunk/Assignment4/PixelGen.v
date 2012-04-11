module PixelGen(
	iData,
	iCoordX,
	iCoordY,
	oNext_Addr,
	oRed,
	oGreen,
	oBlue,
	oVIDEO_ON,
	
	iCLK,
	iRST_N,
);


input iCLK;
input iRST_N;
input [15:0] iData;
input [9:0]	iCoordX;
input [9:0]	iCoordY;
output reg [3:0] oRed;
output reg [3:0] oGreen;
output reg [3:0] oBlue;
output reg [17:0] oNext_Addr; 
output reg oVIDEO_ON;



always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		oNext_Addr <= 0;
		oVIDEO_ON <= 1'b0;
	end
	else
	begin
		if (iCoordX == 639) 
			if (iCoordY == 39)
			begin
				oNext_Addr <= 0;
				oVIDEO_ON <= 1;
			end
			else 
				if (iCoordY >= 440)
				begin
					oNext_Addr <= 0;
					oVIDEO_ON <= 0;
				end
				else
				begin
					oNext_Addr <= (iCoordY-40)*640 + iCoordX + 1;
				end
		else
		begin
			oNext_Addr <= (iCoordY-40)*640 + iCoordX + 1;
		end
	end
end

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		oRed <= 0;
		oGreen <= 0;
		oBlue <= 0;
	end
	else
	begin
		if (iCoordY == 39 && iCoordX == 639)
		begin
			oRed <= iData[11:8];
			oGreen <= iData[7:4];
			oBlue <= iData[3:0];
		end
		else
			if (iCoordY < 40 || iCoordY >= 440 || (iCoordY == 439 && iCoordX == 639))
			begin
				oRed <= 0;
				oGreen <= 0;
				oBlue <= 0;
			end
			else
			begin
				oRed <= iData[11:8];
				oGreen <= iData[7:4];
				oBlue <= iData[3:0];
			end
	end
end

endmodule


