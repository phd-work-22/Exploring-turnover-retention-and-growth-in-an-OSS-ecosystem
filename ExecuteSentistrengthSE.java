/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
/**
 *
 * @author tientulili
 */
package SentimentAnalysis;
import java.io.FileNotFoundException;
import java.io.IOException;

public class ExecuteSentistrengthSE {
    /**
     * @param args the command line arguments
     * @throws java.io.FileNotFoundException
     * @throws java.lang.ClassNotFoundException
     */
    public static void main(String[] args) throws FileNotFoundException, IOException, ClassNotFoundException{
        // Read the files
        // File path is passed as parameter
        String[] params = new String [1];
        params[0] = "/home/p306654/Documents/SEfiles/sentistrength.sh";
        Runtime.getRuntime().exec(params);
    }  
}  
    
