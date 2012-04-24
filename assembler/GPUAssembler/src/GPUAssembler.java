import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.Scanner;

/**
 * 
 */

/**
 * @author jacob
 *
 */
public class GPUAssembler 
{
	private String inputFile;
	private String outputFile;
	
	/**
	 * Constructors
	 * @param inputFile
	 * @param outputFile
	 */
	public GPUAssembler(String inputFile, String outputFile)
	{
		this.inputFile = inputFile;
		this.outputFile = outputFile;
	}
	
	/**
	 * Parses input program and writes out to file
	 * @throws FileNotFoundException 
	 */
	public void parseProgram() throws FileNotFoundException
	{
		// create basic file IO structures
		File input = new File(inputFile);
		Scanner scanner = new Scanner(input);
		File output = new File(outputFile);
		PrintWriter writer = new PrintWriter(output);
		
		// init opcodes
		Opcodes.initMap();
		InstructionFormats.initFormats();
		
		// loop over all lines
		while (scanner.hasNextLine())
		{
			// get line
			String line = scanner.nextLine();
			// parse if non-empty line
			if (line != null)
			{
				line = line.trim();
				if (line.length() > 0)
				{
					String hexLine = InstructionParser.parseInstruction(line);
					writer.println(hexLine);
				}
			}
		}
		
		// close files
		writer.close();
		scanner.close();
		
	}
	
	/**
	 * @param args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException 
	{
		String inputFile = args[0];
		String outputFile = args[1];
		GPUAssembler assembler = new GPUAssembler(inputFile, outputFile);
		
		assembler.parseProgram();
	}

}
