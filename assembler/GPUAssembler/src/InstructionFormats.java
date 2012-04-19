import java.util.HashMap;
import java.util.Map;


/**
 * 
 */

/**
 * Holds mappings for different instruction formats.
 * Used to limit number of comparisons needed when parsing instructions.
 * 
 * @author jacob
 *
 */
public class InstructionFormats 
{
	public static enum Format 
	{ 
		BLANK, 
		IMM16,
		DR1_SR1_SR2,
		DR1_SR1_IMM16,
		SR1_SR2,
		VR1_VR2,
		IDX_VR1_SR1,
		IDX_VR1_IMM16,
		VR1,
		IMM4,
		VR1_IMM16,
		SR1_IMM16
	}
	
	public static Map<String, Format> opcodeToFormatMap;
	
	/**
	 * Inits appropriate sets
	 */
	public static void initFormats()
	{
		opcodeToFormatMap = new HashMap<String, Format>();
		
		opcodeToFormatMap.put(Opcodes.ADD_D, Format.DR1_SR1_SR2);
		opcodeToFormatMap.put(Opcodes.ADDI_D, Format.DR1_SR1_IMM16);
		opcodeToFormatMap.put(Opcodes.ADD_F, Format.DR1_SR1_SR2);
		opcodeToFormatMap.put(Opcodes.ADDI_F, Format.DR1_SR1_IMM16);
		opcodeToFormatMap.put(Opcodes.SUB_D, Format.DR1_SR1_SR2);
		opcodeToFormatMap.put(Opcodes.SUBI_D, Format.DR1_SR1_IMM16);
		opcodeToFormatMap.put(Opcodes.SUB_F, Format.DR1_SR1_SR2);
		opcodeToFormatMap.put(Opcodes.SUBI_F, Format.DR1_SR1_IMM16);
		opcodeToFormatMap.put(Opcodes.MOV, Format.SR1_SR2);
		opcodeToFormatMap.put(Opcodes.MOVI, Format.SR1_IMM16);
		opcodeToFormatMap.put(Opcodes.MOVI_F, Format.SR1_IMM16);
		opcodeToFormatMap.put(Opcodes.VMOV, Format.VR1_VR2);
		opcodeToFormatMap.put(Opcodes.VMOVI, Format.VR1_IMM16);
		opcodeToFormatMap.put(Opcodes.VCOMPMOV, Format.IDX_VR1_SR1);
		opcodeToFormatMap.put(Opcodes.VCOMPMOVI, Format.IDX_VR1_IMM16);
		opcodeToFormatMap.put(Opcodes.SETVERTEX, Format.VR1);
		opcodeToFormatMap.put(Opcodes.COLOR, Format.VR1);
		opcodeToFormatMap.put(Opcodes.ROTATE, Format.VR1);
		opcodeToFormatMap.put(Opcodes.TRANSLATE, Format.VR1);
		opcodeToFormatMap.put(Opcodes.SCALE, Format.VR1);
		opcodeToFormatMap.put(Opcodes.PUSHMATRIX, Format.BLANK);
		opcodeToFormatMap.put(Opcodes.POPMATRIX, Format.BLANK);
		opcodeToFormatMap.put(Opcodes.STARTPRIMITIVE, Format.IMM4);
		opcodeToFormatMap.put(Opcodes.ENDPRIMITIVE, Format.BLANK);
		opcodeToFormatMap.put(Opcodes.LOADIDENTITY, Format.BLANK);
		opcodeToFormatMap.put(Opcodes.DRAW, Format.BLANK);
		opcodeToFormatMap.put(Opcodes.STARTLOOP, Format.BLANK);
		opcodeToFormatMap.put(Opcodes.ENDLOOP, Format.BLANK);
		opcodeToFormatMap.put(Opcodes.LOOPCOUNT, Format.IMM16);
	}
	
	/**
	 * Returns format enum corresponding to hex opcode
	 * @param hexOpcode
	 * @return
	 */
	public static Format getFormat(String hexOpcode)
	{
		return opcodeToFormatMap.get(hexOpcode);
	}
}
