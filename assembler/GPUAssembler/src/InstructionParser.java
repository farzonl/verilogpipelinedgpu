
/**
 * 
 */

/**
 * Parses an individual instruction
 * @author jacob
 *
 */
public class InstructionParser 
{

	/**
	 * Parses assembly instruction and returns hexadecimal version
	 * @param line
	 * @return
	 */
	public static String parseInstruction(String line) 
	{
		String[] tokens = line.split(" ");
		
		// get opcode
		String opcode = Opcodes.getHexOpcode(tokens[0]);
		//System.out.println(tokens[0] + "\t" + opcode);
		// get instruction format
		InstructionFormats.Format format = InstructionFormats.getFormat(opcode);
		
		String instructionRemainder = ""; 
		
		switch (format)
		{
		case IMM16:
			instructionRemainder = parse_IMM16(tokens);
			break;
		case DR1_SR1_SR2:
			instructionRemainder = parse_DR1_SR1_SR2(tokens);
			break;
		case DR1_SR1_IMM16:
			instructionRemainder = parse_DR1_SR1_IMM16(tokens);
			break;
		case SR1_SR2:
			instructionRemainder = parse_SR1_SR2(tokens);
			break;
		case VR1_VR2:
			instructionRemainder = parse_VR1_VR2(tokens);
			break;
		case IDX_VR1_SR1:
			instructionRemainder = parse_IDX_VR1_SR1(tokens);
			break;
		case IDX_VR1_IMM16:
			instructionRemainder = parse_IDX_VR1_IMM16(tokens);
			break;
		case VR1:
			instructionRemainder = parse_VR1(tokens);
			break;
		case IMM4:
			instructionRemainder = parse_IMM4(tokens);
			break;
		case VR1_IMM16:
			instructionRemainder = parse_VR1_IMM16(tokens);
			break;
		case SR1_IMM16:
			instructionRemainder = parse_SR1_IMM16(tokens);
			break;
		case BLANK:
			instructionRemainder = "000000";	// fill remaining with zeroes
			break;
		}
		
		String hexInstruction = opcode + instructionRemainder;
		
		return hexInstruction;
	}

	private static String parse_SR1_IMM16(String[] tokens) 
	{
		// get components
		String sr1_string = getRegNum(tokens[1]);
		String imm16_string = getImm16(tokens[2]);
		
		return ("0" + sr1_string + imm16_string);
	}

	private static String parse_VR1_IMM16(String[] tokens) 
	{
		// get components
		String vr1_string = getVecRegNum8bit(tokens[1]);
		String imm16_string = getImm16(tokens[2]);
		
		return (vr1_string + imm16_string);
	}

	private static String parse_IMM4(String[] tokens) 
	{
		// Get imm4 as string
		String imm4_string = getImm4(tokens[1]);
		
		return ("0" + imm4_string + "0000");
	}

	private static String parse_VR1(String[] tokens) 
	{
		// get vector reg num
		String vr1_str = getVecRegNum8bit(tokens[1]);
		
		return (vr1_str + "0000");
	}

	private static String parse_IDX_VR1_IMM16(String[] tokens) 
	{
		// get idx and vector number as int
		int vr1 = getVecRegNumInt(tokens[1]);
		int idx = getIdx(tokens[2]);
		
		// make sure doesn't have any upper bits on
		vr1 = vr1 & 0x3F;
		
		// calculate upper byte
		int upperByte = (idx << 6) | vr1;
		
		// form upper byte string
		String upper_str = Integer.toHexString(upperByte).toUpperCase();
		
		// make sure limited to 2 characters (1 byte)
		if (upper_str.length() > 2)
		{
			upper_str = upper_str.substring(upper_str.length() - 2, upper_str.length());
		}
		
		// pad upper string is only one character
		while (upper_str.length() < 2)
		{
			upper_str = "0" + upper_str;
		}
		
		// get imm16
		String imm16_str = getImm16(tokens[3]);
		
		return (upper_str + imm16_str);
	}

	private static String parse_IDX_VR1_SR1(String[] tokens) 
	{
		// get idx and vector number as int
		int vr1 = getVecRegNumInt(tokens[1]);
		int idx = getIdx(tokens[2]);
		
		// make sure doesn't have any upper bits on
		vr1 = vr1 & 0x3F;
		
		// calculate upper byte
		int upperByte = (idx << 6) | vr1;
		
		// form upper byte string
		String upper_str = Integer.toHexString(upperByte).toUpperCase();
		
		// make sure limited to 2 characters (1 byte)
		if (upper_str.length() > 2)
		{
			upper_str = upper_str.substring(upper_str.length() - 2, upper_str.length());
		}
		
		// pad upper string is only one character
		while (upper_str.length() < 2)
		{
			upper_str = "0" + upper_str;
		}
		
		// get sr1 value
		String sr1_str = getRegNum(tokens[3]);
		
		
		return (upper_str + "0" + sr1_str + "00");
	}

	private static String parse_VR1_VR2(String[] tokens) 
	{
		// get hex strings for vector registers
		String vr1_str = getVecRegNum8bit(tokens[1]);
		String vr2_str = getVecRegNum8bit(tokens[2]);
		
		return (vr1_str + vr2_str+"00");
	}

	private static String parse_SR1_SR2(String[] tokens) 
	{
		// get hex strings for registers
		String sr1_str = getRegNum(tokens[1]);
		String sr2_str = getRegNum(tokens[2]);
		
		return ("0" + sr1_str + "0" + sr2_str + "00");
	}

	private static String parse_DR1_SR1_IMM16(String[] tokens) 
	{
		// get hex strings for registers
		String dr1_str = getRegNum(tokens[1]);
		String sr1_str = getRegNum(tokens[2]);
		// get string for imm16
		String imm16_str = getImm16(tokens[3]);
		
		return (dr1_str + sr1_str + imm16_str);
	}

	private static String parse_DR1_SR1_SR2(String[] tokens) 
	{
		// get hex strings for registers
		String dr1_str = getRegNum(tokens[1]);
		String sr1_str = getRegNum(tokens[2]);
		String sr2_str = getRegNum(tokens[3]);
		
		// form final string
		return (dr1_str + sr1_str + "0" + sr2_str + "00");
	}

	private static String parse_IMM16(String[] tokens) 
	{
		return ("00" + getImm16(tokens[1]));
	}

	private static String getImm16(String string)
	{	
		String imm16_str = "";
		try	// int case
		{
			int imm16 = Integer.parseInt(string);
			imm16_str = Integer.toHexString(imm16).toUpperCase();
		}
		catch (NumberFormatException e)	// float case
		{
			float imm16 = Float.parseFloat(string);
			// TODO: CONVERT TO FIXED-POINT (VERIFY)
			int imm16_fixed = (int) (imm16 * (1 << 7));
			//imm16_str = Float.toHexString(imm16).toUpperCase();
			imm16_str = Integer.toHexString(imm16_fixed).toUpperCase();
		}
		
		// trim to 16-bits (4 hex components)
		if (imm16_str.length() > 4)
		{
			imm16_str = imm16_str.substring(imm16_str.length() - 4, imm16_str.length());
		}
		
		// add up to 4 zeroes if imm16 doesn't use all 16-bits
		while (imm16_str.length() < 4)
		{
			imm16_str = "0" + imm16_str;
		}
		
		return (imm16_str);
	}
	
	private static String getRegNum(String string)
	{
		// remove prefixed "r" for register
		String reg = string.substring(1, string.length());
		
		// get hex string
		int num = Integer.parseInt(reg);
		String num_str = Integer.toHexString(num).toUpperCase();
		
		// trim to appropriate lengths (4-bits)
		if (num_str.length() > 1)
		{
			num_str = num_str.substring(num_str.length() - 1, num_str.length());
		}
		
		return num_str;
	}
	
	private static String getVecRegNum8bit(String string)
	{
		// remove prefixed "v" for vector register
		String reg = string.substring(1, string.length());
		
		// get number
		int num = Integer.parseInt(reg);
		String num_str = Integer.toHexString(num).toUpperCase();
		
		// trim to appropriate length (6-bits) - actually 8 since we need 2 hex digits
		if (num_str.length() > 2)
		{
			num_str = num_str.substring(num_str.length() - 2, num_str.length());
		}
		
		while (num_str.length() < 2)
		{
			num_str = "0" + num_str;
		}
		
		return num_str;
	}
	
	private static int getVecRegNumInt(String string)
	{
		// remove prefixed "v" for vector register
		String reg = string.substring(1, string.length());
		
		// get number
		int num = Integer.parseInt(reg);
		
		return num;
	}
	
	private static int getIdx(String string)
	{
		return Integer.parseInt(string);
	}
	
	private static String getImm4(String string)
	{		
		String imm4_str = "";
		try	// int case
		{
			int imm4 = Integer.parseInt(string);
			imm4_str = Integer.toHexString(imm4).toUpperCase();
		}
		catch (NumberFormatException e)	// float case
		{
			float imm4 = Float.parseFloat(string);
			// TODO: CONVERT TO FIXED-POINT
			int imm4_fixed = (int) (imm4 * (1 << 7));
			//imm4_str = Float.toHexString(imm4).toUpperCase();
			imm4_str = Integer.toHexString(imm4_fixed).toUpperCase();
		}
		
		// trim to 4-bits (1 hex components)
		if (imm4_str.length() > 1)
		{
			imm4_str = imm4_str.substring(imm4_str.length() - 1, imm4_str.length());
		}
		
		return (imm4_str);
	}
}
