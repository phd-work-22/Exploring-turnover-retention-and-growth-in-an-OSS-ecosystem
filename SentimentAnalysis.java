/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package SentimentAnalysis;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author tien tulili
 */
public class SentimentAnalysis {
    public static void main(String[] args) throws IOException {
        try {  
            Class.forName("com.mysql.cj.jdbc.Driver");  
            try (Connection con = DriverManager.getConnection(  
                    "jdbc:mysql://localhost:3306/mlstats_gentoo","your_username","your_password")) {
               
                Statement stmt=con.createStatement();
                ResultSet rs=stmt.executeQuery(
                        "select message_id, message_body from messages"); 

                String comments; 
                Integer id = 1;
                List<Message_IDs> listID = new ArrayList<>();
                
                
                //write the messages from DB to a file
                try ( //All messages from the database are retrieved and written into a file
                        FileWriter fileWriter = new FileWriter("/your_filepath/gentoo_mlists_2022.txt");
                        PrintWriter printWriter = new PrintWriter(fileWriter)) {
                    //write the messages from DB to a file
                    while(rs.next()) {
                        comments = rs.getString("message_body");
                        listID.add(new Message_IDs(rs.getString("message_id"), id.toString()));
                        printWriter.println(comments+"\n"+"EOF");
                        
                        String query = " insert into shortened_id (short_id, message_id)"
                                 + " values (?, ?)";

                        // create the mysql insert preparedstatement
                      PreparedStatement preparedStmt = con.prepareStatement(query);
                        preparedStmt.setString (1, id.toString());
                        preparedStmt.setString (2, rs.getString("message_id"));
                        id++;
    
                    }
                    printWriter.close();
                }
                /* Read all the comments from the file
                * Each line of the text are normalised
                * We skip all comments containing http, reply message, and sign
                * of the messagess' authors.
                */
                
                File file = new File( "/your_filepath/gentoo_mlists_2022.txt");
                
                try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                    String kommen;
                    String textBuffer="";
                    int i=0;
                    
                    File normFiles = new File( "/your_filepath/gentoo_mlists_normalised_messages_2022.txt");
                    PrintWriter printWriter = new PrintWriter(normFiles);
                    //check each sentence if it contains http, reply message, ignore it
                    while ((kommen = br.readLine()) != null) {
                        //get the id of the message 
                        System.out.println(i);
                        if(i == (id-1)) break;
                        listID.get(i).getMessageID();
                        if ( isNonvalidMessage(kommen) ) continue;
                        if (countWords(kommen) < 4 && matchingWords(kommen) && !kommen.equals("EOF"))
                            continue;
                        if (kommen.equals("EOF") == true) {
                            //if the line reach the EOF, it is the end of the message
                            Pattern re = Pattern.compile
                                    ("[^.!?\\s][^.!?]*(?:[.!?](?!['\"]?\\s|$)[^.!?]*)*[.!?]?['\"]?(?=\\s|$)",
                                            Pattern.MULTILINE | Pattern.COMMENTS);
           
                            Matcher reMatcher = re.matcher(textBuffer);
                            while (reMatcher.find()) {
                                //System.out.println(reMatcher.group());
                                printWriter.println
                                    (listID.get(i).getMessageID()+"\t"+(i+1)+"\t"+reMatcher.group());
                            }
                            textBuffer = "";
                            i++;
                            System.out.println("id: "+i);
                        }
                        else
                            textBuffer += kommen + " ";
                    }   
                    con.close();
                    printWriter.close();
                }
                
            }
            
        }
        catch(ClassNotFoundException | SQLException e) { 
            System.out.println(e);}  
    }
    
    public static boolean isNonvalidMessage(String comments) {       
        return comments.length() == 0 ||  comments.charAt(0) == '>' ||
               comments.charAt(0) == '-' || comments.charAt(0) == '_' || 
               comments.charAt(0) == '[' || comments.charAt(0) == '|' ||
               comments.startsWith("http") || comments.endsWith("wrote:") ||
               comments.startsWith("On ") || comments.charAt(0) == '|';            
    }
    
    public static int countWords(String sentence) {
        int count=0;
        
        StringTokenizer st = new StringTokenizer(sentence);  
        while (st.hasMoreTokens()) {  
            st.nextToken();
            count++ ;
        }
        return count;
    }
    
    public static boolean matchingWords(String string) {
        Pattern re = Pattern.compile("[^\\.?]$", Pattern.MULTILINE | Pattern.COMMENTS);                
        Matcher reMatcher = re.matcher(string);
        return reMatcher.find();
    }
}
