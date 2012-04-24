import java.util.HashMap;
import java.util.Map;

/**
 * 
 */

/**
 * Class to hold opcode hex strings
 * 
 * @author jacob
 *
 */
public class Opcodes 
{
	// opcode constants
	public static final String ADD_D = "00";
	public static final String ADDI_D = "01";
	public static final String ADD_F = "04";
	public static final String ADDI_F = "05";
	public static final String SUB_D = "08";
	public static final String SUBI_D = "09";
	public static final String SUB_F = "0C";
	public static final String SUBI_F = "0D";
	public static final String MOV = "10";
	public static final String MOVI = "11";
	public static final String MOVI_F = "15";
	public static final String VMOV = "12";
	public static final String VMOVI = "13";
	public static final String VCOMPMOV = "22";
	public static final String VCOMPMOVI = "23";
	public static final String SETVERTEX = "42";
	public static final String COLOR = "4A"; 
	public static final String ROTATE = "52"; 
	public static final String TRANSLATE = "5A";
	public static final String SCALE = "62";
	public static final String PUSHMATRIX = "80";
	public static final String POPMATRIX = "88"; 
	public static final String STARTPRIMITIVE = "91";
	public static final String ENDPRIMITIVE = "98";
	public static final String LOADIDENTITY = "A0";
	public static final String DRAW = "B8";
	public static final String STARTLOOP = "C0";
	public static final String ENDLOOP = "C8";
	public static final String LOOPCOUNT = "D1";
	
	
	// map of asm opcode to hex opcode
	public static Map<String, String> opcodeMap;
	
	/**
	 * Initializes map of opcodes
	 */
	public static void initMap()
	{
		opcodeMap = new HashMap<String, String>();
		
		opcodeMap.put("add.d", ADD_D);
		opcodeMap.put("addi.d", ADDI_D);
		opcodeMap.put("add.f", ADD_F);
		opcodeMap.put("addi.f", ADDI_F);
		opcodeMap.put("sub.d", SUB_D);
		opcodeMap.put("subi.d", SUBI_D);
		opcodeMap.put("sub.f", SUB_F);
		opcodeMap.put("subi.f", SUBI_F);
		opcodeMap.put("mov", MOV);
		opcodeMap.put("movi", MOVI);
		opcodeMap.put("movi.f", MOVI_F);
		opcodeMap.put("vmov", VMOV);
		opcodeMap.put("vmovi", VMOVI);
		opcodeMap.put("vcompmov", VCOMPMOV);
		opcodeMap.put("vcompmovi", VCOMPMOVI);
		opcodeMap.put("setvertex", SETVERTEX);
		opcodeMap.put("color", COLOR);
		opcodeMap.put("rotate", ROTATE);
		opcodeMap.put("translate", TRANSLATE);
		opcodeMap.put("scale", SCALE);
		opcodeMap.put("pushmatrix", PUSHMATRIX);
		opcodeMap.put("popmatrix", POPMATRIX);
		opcodeMap.put("startprimitive", STARTPRIMITIVE);
		opcodeMap.put("endprimitive", ENDPRIMITIVE);
		opcodeMap.put("loadidentity", LOADIDENTITY);
		opcodeMap.put("draw", DRAW);
		opcodeMap.put("startloop", STARTLOOP);
		opcodeMap.put("endloop", ENDLOOP);
		opcodeMap.put("loopcount", LOOPCOUNT);
	}
	
	/**
	 * Returns hex opcode given asm opcode
	 * @param asmOpcode
	 * @return
	 */
	public static String getHexOpcode(String asmOpcode)
	{
		return opcodeMap.get(asmOpcode);
	}
}
