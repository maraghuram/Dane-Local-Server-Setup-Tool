/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ldane;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author raghuram
 */
public class CommandExecuter {
    
    public CommandExecuter(){
        
    }
    
       
    public String executeCommand(String[] command){
        StringBuffer output = new StringBuffer();
        
        ProcessBuilder builder = new ProcessBuilder();
        builder.redirectErrorStream(true);
        builder.command(command);
        try{
        Process p = builder.start();
        p.waitFor();
        BufferedReader reader =  new BufferedReader(new InputStreamReader(p.getInputStream()));
 
			String line = "";			
			while ((line = reader.readLine())!= null) {
				output.append(line + "\n");
			}
        }catch(IOException e){
            e.printStackTrace();
        } catch (InterruptedException ex) {
            Logger.getLogger(CommandExecuter.class.getName()).log(Level.SEVERE, null, ex);
        }
        return output.toString();
    }
  
   /*public String executeCommand(String command) {
 
		StringBuffer output = new StringBuffer();
                
		Process p;
		try {   ProcessBuilder.redirectErrorStream(true);
			p = Runtime.getRuntime().exec(command);                        
                        ProcessBuilder pb = new ProcessBuilder("ShellScripts/AuthoritativeServer.sh", "a.myroot-servers.loc", "10.100.14.206");
                        pb.
			p.waitFor();               
                           p.
                           new BufferedReader(new InputStreamReader(p.getInputStream()));
 
			String line = "";			
			while ((line = reader.readLine())!= null) {
				output.append(line + "\n");
			}
 
		} catch (Exception e) {
			e.printStackTrace();
		}
 
		return output.toString();
 
	}
    */
    
}
