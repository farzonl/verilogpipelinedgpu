//Returns cos(INVAL) where INVAL is in the range [-255,255] in 1.8.7 format

module cosine_LUT(INVAL,OUTVAL);
input[15:0] INVAL;
output[15:0] OUTVAL;

//Round INVAL to the nearest degree
wire[15:0] INVAL_rounded = (INVAL[15] == 1 && INVAL[7] == 1'b1) ? {INVAL[15:7] - 1'b1,7'b0} : (INVAL[15] == 0 && INVAL[7] == 1'b1) ? {INVAL[15:7] + 1'b1,7'b0} : {INVAL[15:7],7'b0};

assign OUTVAL = (INVAL_rounded == 16'h0 || INVAL_rounded == 16'h0) ? 16'h80 : 
				(INVAL_rounded == 16'h80 || INVAL_rounded == 16'hff80) ? 16'h80 : 
				(INVAL_rounded == 16'h100 || INVAL_rounded == 16'hff00) ? 16'h80 : 
				(INVAL_rounded == 16'h180 || INVAL_rounded == 16'hfe80) ? 16'h80 : 
				(INVAL_rounded == 16'h200 || INVAL_rounded == 16'hfe00) ? 16'h80 : 
				(INVAL_rounded == 16'h280 || INVAL_rounded == 16'hfd80) ? 16'h80 : 
				(INVAL_rounded == 16'h300 || INVAL_rounded == 16'hfd00) ? 16'h7f : 
				(INVAL_rounded == 16'h380 || INVAL_rounded == 16'hfc80) ? 16'h7f : 
				(INVAL_rounded == 16'h400 || INVAL_rounded == 16'hfc00) ? 16'h7f : 
				(INVAL_rounded == 16'h480 || INVAL_rounded == 16'hfb80) ? 16'h7e : 
				(INVAL_rounded == 16'h500 || INVAL_rounded == 16'hfb00) ? 16'h7e : 
				(INVAL_rounded == 16'h580 || INVAL_rounded == 16'hfa80) ? 16'h7e : 
				(INVAL_rounded == 16'h600 || INVAL_rounded == 16'hfa00) ? 16'h7d : 
				(INVAL_rounded == 16'h680 || INVAL_rounded == 16'hf980) ? 16'h7d : 
				(INVAL_rounded == 16'h700 || INVAL_rounded == 16'hf900) ? 16'h7c : 
				(INVAL_rounded == 16'h780 || INVAL_rounded == 16'hf880) ? 16'h7c : 
				(INVAL_rounded == 16'h800 || INVAL_rounded == 16'hf800) ? 16'h7b : 
				(INVAL_rounded == 16'h880 || INVAL_rounded == 16'hf780) ? 16'h7a : 
				(INVAL_rounded == 16'h900 || INVAL_rounded == 16'hf700) ? 16'h7a : 
				(INVAL_rounded == 16'h980 || INVAL_rounded == 16'hf680) ? 16'h79 : 
				(INVAL_rounded == 16'ha00 || INVAL_rounded == 16'hf600) ? 16'h78 : 
				(INVAL_rounded == 16'ha80 || INVAL_rounded == 16'hf580) ? 16'h77 : 
				(INVAL_rounded == 16'hb00 || INVAL_rounded == 16'hf500) ? 16'h77 : 
				(INVAL_rounded == 16'hb80 || INVAL_rounded == 16'hf480) ? 16'h76 : 
				(INVAL_rounded == 16'hc00 || INVAL_rounded == 16'hf400) ? 16'h75 : 
				(INVAL_rounded == 16'hc80 || INVAL_rounded == 16'hf380) ? 16'h74 : 
				(INVAL_rounded == 16'hd00 || INVAL_rounded == 16'hf300) ? 16'h73 : 
				(INVAL_rounded == 16'hd80 || INVAL_rounded == 16'hf280) ? 16'h72 : 
				(INVAL_rounded == 16'he00 || INVAL_rounded == 16'hf200) ? 16'h71 : 
				(INVAL_rounded == 16'he80 || INVAL_rounded == 16'hf180) ? 16'h70 : 
				(INVAL_rounded == 16'hf00 || INVAL_rounded == 16'hf100) ? 16'h6f : 
				(INVAL_rounded == 16'hf80 || INVAL_rounded == 16'hf080) ? 16'h6e : 
				(INVAL_rounded == 16'h1000 || INVAL_rounded == 16'hf000) ? 16'h6d : 
				(INVAL_rounded == 16'h1080 || INVAL_rounded == 16'hef80) ? 16'h6b : 
				(INVAL_rounded == 16'h1100 || INVAL_rounded == 16'hef00) ? 16'h6a : 
				(INVAL_rounded == 16'h1180 || INVAL_rounded == 16'hee80) ? 16'h69 : 
				(INVAL_rounded == 16'h1200 || INVAL_rounded == 16'hee00) ? 16'h68 : 
				(INVAL_rounded == 16'h1280 || INVAL_rounded == 16'hed80) ? 16'h66 : 
				(INVAL_rounded == 16'h1300 || INVAL_rounded == 16'hed00) ? 16'h65 : 
				(INVAL_rounded == 16'h1380 || INVAL_rounded == 16'hec80) ? 16'h63 : 
				(INVAL_rounded == 16'h1400 || INVAL_rounded == 16'hec00) ? 16'h62 : 
				(INVAL_rounded == 16'h1480 || INVAL_rounded == 16'heb80) ? 16'h61 : 
				(INVAL_rounded == 16'h1500 || INVAL_rounded == 16'heb00) ? 16'h5f : 
				(INVAL_rounded == 16'h1580 || INVAL_rounded == 16'hea80) ? 16'h5e : 
				(INVAL_rounded == 16'h1600 || INVAL_rounded == 16'hea00) ? 16'h5c : 
				(INVAL_rounded == 16'h1680 || INVAL_rounded == 16'he980) ? 16'h5b : 
				(INVAL_rounded == 16'h1700 || INVAL_rounded == 16'he900) ? 16'h59 : 
				(INVAL_rounded == 16'h1780 || INVAL_rounded == 16'he880) ? 16'h57 : 
				(INVAL_rounded == 16'h1800 || INVAL_rounded == 16'he800) ? 16'h56 : 
				(INVAL_rounded == 16'h1880 || INVAL_rounded == 16'he780) ? 16'h54 : 
				(INVAL_rounded == 16'h1900 || INVAL_rounded == 16'he700) ? 16'h52 : 
				(INVAL_rounded == 16'h1980 || INVAL_rounded == 16'he680) ? 16'h51 : 
				(INVAL_rounded == 16'h1a00 || INVAL_rounded == 16'he600) ? 16'h4f : 
				(INVAL_rounded == 16'h1a80 || INVAL_rounded == 16'he580) ? 16'h4d : 
				(INVAL_rounded == 16'h1b00 || INVAL_rounded == 16'he500) ? 16'h4b : 
				(INVAL_rounded == 16'h1b80 || INVAL_rounded == 16'he480) ? 16'h49 : 
				(INVAL_rounded == 16'h1c00 || INVAL_rounded == 16'he400) ? 16'h48 : 
				(INVAL_rounded == 16'h1c80 || INVAL_rounded == 16'he380) ? 16'h46 : 
				(INVAL_rounded == 16'h1d00 || INVAL_rounded == 16'he300) ? 16'h44 : 
				(INVAL_rounded == 16'h1d80 || INVAL_rounded == 16'he280) ? 16'h42 : 
				(INVAL_rounded == 16'h1e00 || INVAL_rounded == 16'he200) ? 16'h40 : 
				(INVAL_rounded == 16'h1e80 || INVAL_rounded == 16'he180) ? 16'h3e : 
				(INVAL_rounded == 16'h1f00 || INVAL_rounded == 16'he100) ? 16'h3c : 
				(INVAL_rounded == 16'h1f80 || INVAL_rounded == 16'he080) ? 16'h3a : 
				(INVAL_rounded == 16'h2000 || INVAL_rounded == 16'he000) ? 16'h38 : 
				(INVAL_rounded == 16'h2080 || INVAL_rounded == 16'hdf80) ? 16'h36 : 
				(INVAL_rounded == 16'h2100 || INVAL_rounded == 16'hdf00) ? 16'h34 : 
				(INVAL_rounded == 16'h2180 || INVAL_rounded == 16'hde80) ? 16'h32 : 
				(INVAL_rounded == 16'h2200 || INVAL_rounded == 16'hde00) ? 16'h30 : 
				(INVAL_rounded == 16'h2280 || INVAL_rounded == 16'hdd80) ? 16'h2e : 
				(INVAL_rounded == 16'h2300 || INVAL_rounded == 16'hdd00) ? 16'h2c : 
				(INVAL_rounded == 16'h2380 || INVAL_rounded == 16'hdc80) ? 16'h2a : 
				(INVAL_rounded == 16'h2400 || INVAL_rounded == 16'hdc00) ? 16'h28 : 
				(INVAL_rounded == 16'h2480 || INVAL_rounded == 16'hdb80) ? 16'h25 : 
				(INVAL_rounded == 16'h2500 || INVAL_rounded == 16'hdb00) ? 16'h23 : 
				(INVAL_rounded == 16'h2580 || INVAL_rounded == 16'hda80) ? 16'h21 : 
				(INVAL_rounded == 16'h2600 || INVAL_rounded == 16'hda00) ? 16'h1f : 
				(INVAL_rounded == 16'h2680 || INVAL_rounded == 16'hd980) ? 16'h1d : 
				(INVAL_rounded == 16'h2700 || INVAL_rounded == 16'hd900) ? 16'h1b : 
				(INVAL_rounded == 16'h2780 || INVAL_rounded == 16'hd880) ? 16'h18 : 
				(INVAL_rounded == 16'h2800 || INVAL_rounded == 16'hd800) ? 16'h16 : 
				(INVAL_rounded == 16'h2880 || INVAL_rounded == 16'hd780) ? 16'h14 : 
				(INVAL_rounded == 16'h2900 || INVAL_rounded == 16'hd700) ? 16'h12 : 
				(INVAL_rounded == 16'h2980 || INVAL_rounded == 16'hd680) ? 16'h10 : 
				(INVAL_rounded == 16'h2a00 || INVAL_rounded == 16'hd600) ? 16'hd : 
				(INVAL_rounded == 16'h2a80 || INVAL_rounded == 16'hd580) ? 16'hb : 
				(INVAL_rounded == 16'h2b00 || INVAL_rounded == 16'hd500) ? 16'h9 : 
				(INVAL_rounded == 16'h2b80 || INVAL_rounded == 16'hd480) ? 16'h7 : 
				(INVAL_rounded == 16'h2c00 || INVAL_rounded == 16'hd400) ? 16'h4 : 
				(INVAL_rounded == 16'h2c80 || INVAL_rounded == 16'hd380) ? 16'h2 : 
				(INVAL_rounded == 16'h2d00 || INVAL_rounded == 16'hd300) ? 16'h0 : 
				(INVAL_rounded == 16'h2d80 || INVAL_rounded == 16'hd280) ? 16'hfffe : 
				(INVAL_rounded == 16'h2e00 || INVAL_rounded == 16'hd200) ? 16'hfffc : 
				(INVAL_rounded == 16'h2e80 || INVAL_rounded == 16'hd180) ? 16'hfff9 : 
				(INVAL_rounded == 16'h2f00 || INVAL_rounded == 16'hd100) ? 16'hfff7 : 
				(INVAL_rounded == 16'h2f80 || INVAL_rounded == 16'hd080) ? 16'hfff5 : 
				(INVAL_rounded == 16'h3000 || INVAL_rounded == 16'hd000) ? 16'hfff3 : 
				(INVAL_rounded == 16'h3080 || INVAL_rounded == 16'hcf80) ? 16'hfff0 : 
				(INVAL_rounded == 16'h3100 || INVAL_rounded == 16'hcf00) ? 16'hffee : 
				(INVAL_rounded == 16'h3180 || INVAL_rounded == 16'hce80) ? 16'hffec : 
				(INVAL_rounded == 16'h3200 || INVAL_rounded == 16'hce00) ? 16'hffea : 
				(INVAL_rounded == 16'h3280 || INVAL_rounded == 16'hcd80) ? 16'hffe8 : 
				(INVAL_rounded == 16'h3300 || INVAL_rounded == 16'hcd00) ? 16'hffe5 : 
				(INVAL_rounded == 16'h3380 || INVAL_rounded == 16'hcc80) ? 16'hffe3 : 
				(INVAL_rounded == 16'h3400 || INVAL_rounded == 16'hcc00) ? 16'hffe1 : 
				(INVAL_rounded == 16'h3480 || INVAL_rounded == 16'hcb80 || INVAL_rounded == 16'h7f80 || INVAL_rounded == 16'h8080) ? 16'hffdf : 
				(INVAL_rounded == 16'h3500 || INVAL_rounded == 16'hcb00 || INVAL_rounded == 16'h7f00 || INVAL_rounded == 16'h8100) ? 16'hffdd : 
				(INVAL_rounded == 16'h3580 || INVAL_rounded == 16'hca80 || INVAL_rounded == 16'h7e80 || INVAL_rounded == 16'h8180) ? 16'hffdb : 
				(INVAL_rounded == 16'h3600 || INVAL_rounded == 16'hca00 || INVAL_rounded == 16'h7e00 || INVAL_rounded == 16'h8200) ? 16'hffd8 : 
				(INVAL_rounded == 16'h3680 || INVAL_rounded == 16'hc980 || INVAL_rounded == 16'h7d80 || INVAL_rounded == 16'h8280) ? 16'hffd6 : 
				(INVAL_rounded == 16'h3700 || INVAL_rounded == 16'hc900 || INVAL_rounded == 16'h7d00 || INVAL_rounded == 16'h8300) ? 16'hffd4 : 
				(INVAL_rounded == 16'h3780 || INVAL_rounded == 16'hc880 || INVAL_rounded == 16'h7c80 || INVAL_rounded == 16'h8380) ? 16'hffd2 : 
				(INVAL_rounded == 16'h3800 || INVAL_rounded == 16'hc800 || INVAL_rounded == 16'h7c00 || INVAL_rounded == 16'h8400) ? 16'hffd0 : 
				(INVAL_rounded == 16'h3880 || INVAL_rounded == 16'hc780 || INVAL_rounded == 16'h7b80 || INVAL_rounded == 16'h8480) ? 16'hffce : 
				(INVAL_rounded == 16'h3900 || INVAL_rounded == 16'hc700 || INVAL_rounded == 16'h7b00 || INVAL_rounded == 16'h8500) ? 16'hffcc : 
				(INVAL_rounded == 16'h3980 || INVAL_rounded == 16'hc680 || INVAL_rounded == 16'h7a80 || INVAL_rounded == 16'h8580) ? 16'hffca : 
				(INVAL_rounded == 16'h3a00 || INVAL_rounded == 16'hc600 || INVAL_rounded == 16'h7a00 || INVAL_rounded == 16'h8600) ? 16'hffc8 : 
				(INVAL_rounded == 16'h3a80 || INVAL_rounded == 16'hc580 || INVAL_rounded == 16'h7980 || INVAL_rounded == 16'h8680) ? 16'hffc6 : 
				(INVAL_rounded == 16'h3b00 || INVAL_rounded == 16'hc500 || INVAL_rounded == 16'h7900 || INVAL_rounded == 16'h8700) ? 16'hffc4 : 
				(INVAL_rounded == 16'h3b80 || INVAL_rounded == 16'hc480 || INVAL_rounded == 16'h7880 || INVAL_rounded == 16'h8780) ? 16'hffc2 : 
				(INVAL_rounded == 16'h3c00 || INVAL_rounded == 16'hc400 || INVAL_rounded == 16'h7800 || INVAL_rounded == 16'h8800) ? 16'hffc0 : 
				(INVAL_rounded == 16'h3c80 || INVAL_rounded == 16'hc380 || INVAL_rounded == 16'h7780 || INVAL_rounded == 16'h8880) ? 16'hffbe : 
				(INVAL_rounded == 16'h3d00 || INVAL_rounded == 16'hc300 || INVAL_rounded == 16'h7700 || INVAL_rounded == 16'h8900) ? 16'hffbc : 
				(INVAL_rounded == 16'h3d80 || INVAL_rounded == 16'hc280 || INVAL_rounded == 16'h7680 || INVAL_rounded == 16'h8980) ? 16'hffba : 
				(INVAL_rounded == 16'h3e00 || INVAL_rounded == 16'hc200 || INVAL_rounded == 16'h7600 || INVAL_rounded == 16'h8a00) ? 16'hffb8 : 
				(INVAL_rounded == 16'h3e80 || INVAL_rounded == 16'hc180 || INVAL_rounded == 16'h7580 || INVAL_rounded == 16'h8a80) ? 16'hffb7 : 
				(INVAL_rounded == 16'h3f00 || INVAL_rounded == 16'hc100 || INVAL_rounded == 16'h7500 || INVAL_rounded == 16'h8b00) ? 16'hffb5 : 
				(INVAL_rounded == 16'h3f80 || INVAL_rounded == 16'hc080 || INVAL_rounded == 16'h7480 || INVAL_rounded == 16'h8b80) ? 16'hffb3 : 
				(INVAL_rounded == 16'h4000 || INVAL_rounded == 16'hc000 || INVAL_rounded == 16'h7400 || INVAL_rounded == 16'h8c00) ? 16'hffb1 : 
				(INVAL_rounded == 16'h4080 || INVAL_rounded == 16'hbf80 || INVAL_rounded == 16'h7380 || INVAL_rounded == 16'h8c80) ? 16'hffaf : 
				(INVAL_rounded == 16'h4100 || INVAL_rounded == 16'hbf00 || INVAL_rounded == 16'h7300 || INVAL_rounded == 16'h8d00) ? 16'hffae : 
				(INVAL_rounded == 16'h4180 || INVAL_rounded == 16'hbe80 || INVAL_rounded == 16'h7280 || INVAL_rounded == 16'h8d80) ? 16'hffac : 
				(INVAL_rounded == 16'h4200 || INVAL_rounded == 16'hbe00 || INVAL_rounded == 16'h7200 || INVAL_rounded == 16'h8e00) ? 16'hffaa : 
				(INVAL_rounded == 16'h4280 || INVAL_rounded == 16'hbd80 || INVAL_rounded == 16'h7180 || INVAL_rounded == 16'h8e80) ? 16'hffa9 : 
				(INVAL_rounded == 16'h4300 || INVAL_rounded == 16'hbd00 || INVAL_rounded == 16'h7100 || INVAL_rounded == 16'h8f00) ? 16'hffa7 : 
				(INVAL_rounded == 16'h4380 || INVAL_rounded == 16'hbc80 || INVAL_rounded == 16'h7080 || INVAL_rounded == 16'h8f80) ? 16'hffa5 : 
				(INVAL_rounded == 16'h4400 || INVAL_rounded == 16'hbc00 || INVAL_rounded == 16'h7000 || INVAL_rounded == 16'h9000) ? 16'hffa4 : 
				(INVAL_rounded == 16'h4480 || INVAL_rounded == 16'hbb80 || INVAL_rounded == 16'h6f80 || INVAL_rounded == 16'h9080) ? 16'hffa2 : 
				(INVAL_rounded == 16'h4500 || INVAL_rounded == 16'hbb00 || INVAL_rounded == 16'h6f00 || INVAL_rounded == 16'h9100) ? 16'hffa1 : 
				(INVAL_rounded == 16'h4580 || INVAL_rounded == 16'hba80 || INVAL_rounded == 16'h6e80 || INVAL_rounded == 16'h9180) ? 16'hff9f : 
				(INVAL_rounded == 16'h4600 || INVAL_rounded == 16'hba00 || INVAL_rounded == 16'h6e00 || INVAL_rounded == 16'h9200) ? 16'hff9e : 
				(INVAL_rounded == 16'h4680 || INVAL_rounded == 16'hb980 || INVAL_rounded == 16'h6d80 || INVAL_rounded == 16'h9280) ? 16'hff9d : 
				(INVAL_rounded == 16'h4700 || INVAL_rounded == 16'hb900 || INVAL_rounded == 16'h6d00 || INVAL_rounded == 16'h9300) ? 16'hff9b : 
				(INVAL_rounded == 16'h4780 || INVAL_rounded == 16'hb880 || INVAL_rounded == 16'h6c80 || INVAL_rounded == 16'h9380) ? 16'hff9a : 
				(INVAL_rounded == 16'h4800 || INVAL_rounded == 16'hb800 || INVAL_rounded == 16'h6c00 || INVAL_rounded == 16'h9400) ? 16'hff98 : 
				(INVAL_rounded == 16'h4880 || INVAL_rounded == 16'hb780 || INVAL_rounded == 16'h6b80 || INVAL_rounded == 16'h9480) ? 16'hff97 : 
				(INVAL_rounded == 16'h4900 || INVAL_rounded == 16'hb700 || INVAL_rounded == 16'h6b00 || INVAL_rounded == 16'h9500) ? 16'hff96 : 
				(INVAL_rounded == 16'h4980 || INVAL_rounded == 16'hb680 || INVAL_rounded == 16'h6a80 || INVAL_rounded == 16'h9580) ? 16'hff95 : 
				(INVAL_rounded == 16'h4a00 || INVAL_rounded == 16'hb600 || INVAL_rounded == 16'h6a00 || INVAL_rounded == 16'h9600) ? 16'hff93 : 
				(INVAL_rounded == 16'h4a80 || INVAL_rounded == 16'hb580 || INVAL_rounded == 16'h6980 || INVAL_rounded == 16'h9680) ? 16'hff92 : 
				(INVAL_rounded == 16'h4b00 || INVAL_rounded == 16'hb500 || INVAL_rounded == 16'h6900 || INVAL_rounded == 16'h9700) ? 16'hff91 : 
				(INVAL_rounded == 16'h4b80 || INVAL_rounded == 16'hb480 || INVAL_rounded == 16'h6880 || INVAL_rounded == 16'h9780) ? 16'hff90 : 
				(INVAL_rounded == 16'h4c00 || INVAL_rounded == 16'hb400 || INVAL_rounded == 16'h6800 || INVAL_rounded == 16'h9800) ? 16'hff8f : 
				(INVAL_rounded == 16'h4c80 || INVAL_rounded == 16'hb380 || INVAL_rounded == 16'h6780 || INVAL_rounded == 16'h9880) ? 16'hff8e : 
				(INVAL_rounded == 16'h4d00 || INVAL_rounded == 16'hb300 || INVAL_rounded == 16'h6700 || INVAL_rounded == 16'h9900) ? 16'hff8d : 
				(INVAL_rounded == 16'h4d80 || INVAL_rounded == 16'hb280 || INVAL_rounded == 16'h6680 || INVAL_rounded == 16'h9980) ? 16'hff8c : 
				(INVAL_rounded == 16'h4e00 || INVAL_rounded == 16'hb200 || INVAL_rounded == 16'h6600 || INVAL_rounded == 16'h9a00) ? 16'hff8b : 
				(INVAL_rounded == 16'h4e80 || INVAL_rounded == 16'hb180 || INVAL_rounded == 16'h6580 || INVAL_rounded == 16'h9a80) ? 16'hff8a : 
				(INVAL_rounded == 16'h4f00 || INVAL_rounded == 16'hb100 || INVAL_rounded == 16'h6500 || INVAL_rounded == 16'h9b00) ? 16'hff89 : 
				(INVAL_rounded == 16'h4f80 || INVAL_rounded == 16'hb080 || INVAL_rounded == 16'h6480 || INVAL_rounded == 16'h9b80) ? 16'hff89 : 
				(INVAL_rounded == 16'h5000 || INVAL_rounded == 16'hb000 || INVAL_rounded == 16'h6400 || INVAL_rounded == 16'h9c00) ? 16'hff88 : 
				(INVAL_rounded == 16'h5080 || INVAL_rounded == 16'haf80 || INVAL_rounded == 16'h6380 || INVAL_rounded == 16'h9c80) ? 16'hff87 : 
				(INVAL_rounded == 16'h5100 || INVAL_rounded == 16'haf00 || INVAL_rounded == 16'h6300 || INVAL_rounded == 16'h9d00) ? 16'hff86 : 
				(INVAL_rounded == 16'h5180 || INVAL_rounded == 16'hae80 || INVAL_rounded == 16'h6280 || INVAL_rounded == 16'h9d80) ? 16'hff86 : 
				(INVAL_rounded == 16'h5200 || INVAL_rounded == 16'hae00 || INVAL_rounded == 16'h6200 || INVAL_rounded == 16'h9e00) ? 16'hff85 : 
				(INVAL_rounded == 16'h5280 || INVAL_rounded == 16'had80 || INVAL_rounded == 16'h6180 || INVAL_rounded == 16'h9e80) ? 16'hff84 : 
				(INVAL_rounded == 16'h5300 || INVAL_rounded == 16'had00 || INVAL_rounded == 16'h6100 || INVAL_rounded == 16'h9f00) ? 16'hff84 : 
				(INVAL_rounded == 16'h5380 || INVAL_rounded == 16'hac80 || INVAL_rounded == 16'h6080 || INVAL_rounded == 16'h9f80) ? 16'hff83 : 
				(INVAL_rounded == 16'h5400 || INVAL_rounded == 16'hac00 || INVAL_rounded == 16'h6000 || INVAL_rounded == 16'ha000) ? 16'hff83 : 
				(INVAL_rounded == 16'h5480 || INVAL_rounded == 16'hab80 || INVAL_rounded == 16'h5f80 || INVAL_rounded == 16'ha080) ? 16'hff82 : 
				(INVAL_rounded == 16'h5500 || INVAL_rounded == 16'hab00 || INVAL_rounded == 16'h5f00 || INVAL_rounded == 16'ha100) ? 16'hff82 : 
				(INVAL_rounded == 16'h5580 || INVAL_rounded == 16'haa80 || INVAL_rounded == 16'h5e80 || INVAL_rounded == 16'ha180) ? 16'hff82 : 
				(INVAL_rounded == 16'h5600 || INVAL_rounded == 16'haa00 || INVAL_rounded == 16'h5e00 || INVAL_rounded == 16'ha200) ? 16'hff81 : 
				(INVAL_rounded == 16'h5680 || INVAL_rounded == 16'ha980 || INVAL_rounded == 16'h5d80 || INVAL_rounded == 16'ha280) ? 16'hff81 : 
				(INVAL_rounded == 16'h5700 || INVAL_rounded == 16'ha900 || INVAL_rounded == 16'h5d00 || INVAL_rounded == 16'ha300) ? 16'hff81 : 
				(INVAL_rounded == 16'h5780 || INVAL_rounded == 16'ha880 || INVAL_rounded == 16'h5c80 || INVAL_rounded == 16'ha380) ? 16'hff80 : 
				(INVAL_rounded == 16'h5800 || INVAL_rounded == 16'ha800 || INVAL_rounded == 16'h5c00 || INVAL_rounded == 16'ha400) ? 16'hff80 : 
				(INVAL_rounded == 16'h5880 || INVAL_rounded == 16'ha780 || INVAL_rounded == 16'h5b80 || INVAL_rounded == 16'ha480) ? 16'hff80 : 
				(INVAL_rounded == 16'h5900 || INVAL_rounded == 16'ha700 || INVAL_rounded == 16'h5b00 || INVAL_rounded == 16'ha500) ? 16'hff80 : 
				(INVAL_rounded == 16'h5980 || INVAL_rounded == 16'ha680 || INVAL_rounded == 16'h5a80 || INVAL_rounded == 16'ha580) ? 16'hff80 : 
				(INVAL_rounded == 16'h5a00 || INVAL_rounded == 16'ha600) ? 16'hff80 : 16'hXXXX;
endmodule
