/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package SentimentAnalysis;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

/**
 *
 * @author p306654
 */
public class InsertingResults {
    public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException,
            NumberFormatException{
        try {  
            Class.forName("com.mysql.cj.jdbc.Driver");  
            try (Connection con = DriverManager.getConnection(  
                    "jdbc:mysql://localhost:3306/mlstats_gentoo","admin","Admin@123")) {
                
                String query = " insert into sentiments_on_messages "
                             + "(message_id, sentence, pos_score, neg_score)"
                                     + " values (?, ?, ?, ?)";

                // create the mysql insert preparedstatement
                PreparedStatement preparedStmt = con.prepareStatement(query);

                File file = 
    //              new File("/home/p306654/Documents/SEfiles/results of sentiment classification/bugzilla_results_classification"+fileNo+".txt");
                    new File("/home/p306654/Documents/SEfiles/gentooMlistsFiles/results_of_classification_GentooMlists2023.txt");
                        try (BufferedReader buffread = new BufferedReader(new FileReader(file))) { 
                    String sentence;


                    List<RecordSA> listRecords = new ArrayList<>();
                    List<String> listTokens = new ArrayList<>();
                    List<Integer> listScores = new ArrayList<>();
                    int idx=0, i=0;    
                    while ((sentence = buffread.readLine()) != null) {
                        RecordSA record = new RecordSA();
                        int flag=0;
                        StringTokenizer st = new StringTokenizer(sentence,"\t");    
                        while (st.hasMoreTokens())   
                        {   
                            String string = st.nextToken();   
                            listTokens.add(string);
                           flag++;

                        }
                        //System.out.println(flag);
                        if (flag == 4) {
                            record.setMessageID(listTokens.get(i));
                            record.setSentence(listTokens.get(i+2));
                            StringTokenizer st2 = new StringTokenizer(listTokens.get(i+3)," ");    
                            while (st2.hasMoreTokens())   
                            { 

                                String str = st2.nextToken();
                                Integer score = Integer.parseInt(str);
                                listScores.add(score);

                            }
                            i+=4;
                        }
                        else {
                            record.setMessageID(listTokens.get(i));
                            String strtemp = "";
                            for(int j=i+2; j< (flag+i)-1 ; j++) {
                                    strtemp = strtemp + listTokens.get(j);
                                    //System.out.println(strtemp);
                            }
                            //System.out.println(strtemp);
                            record.setSentence(strtemp);
                            StringTokenizer st2 = new StringTokenizer(listTokens.get(i+flag-1)," ");    
                            while (st2.hasMoreTokens())   
                            { 
                                String str = st2.nextToken();    
                                Integer score = Integer.parseInt(str);
                                listScores.add(score);

                            }
                            i+=flag;
                        }

                        record.setPosScore(listScores.get(idx));
                        record.setNegScore(listScores.get(idx+1));
                        listRecords.add(record);
                        idx+=2;
                    }

                    for(RecordSA tempRecords : listRecords) {
                        preparedStmt.setString (1, tempRecords.getMessageID());
                        preparedStmt.setString (2, tempRecords.getSentence());
                        preparedStmt.setInt (3, tempRecords.getPosScore());
                        preparedStmt.setInt (4, tempRecords.getNegScore());
                        preparedStmt.execute();  
                    } 
                }
                } 
        }
        catch(SQLException e) { 
                System.out.println(e); 
        }     
    }
}
