/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package SentimentAnalysis;

/**
 *
 * @author p306654
 */
public class RecordSA {
        private String message_ID;
        private String sentence;
        private int posScore;
        private int negScore;
        
        public RecordSA(){
            
        }
        public RecordSA(String message_ID, String sentence, int posScore, int negScore){
            this.message_ID = message_ID;
            this.sentence = sentence;
            this.posScore = posScore;
            this.negScore = negScore;
        }
        
        public RecordSA(String message_ID){
            this.message_ID = message_ID;
        }
        
        
        public String getMessageID () {
            return message_ID;
        } 
        
        public String getSentence() {
            return sentence;
        }
        
        public int getPosScore() {
            return posScore;
        }
        
        public int getNegScore() {
            return negScore;
        }
        
        public void setMessageID (String message_ID) {
            this.message_ID = message_ID;
        }
        
        
        public void setSentence(String sentence) {
            this.sentence = sentence;
        }
        
        public void setPosScore(int posScore) {
            this.posScore = posScore;
        }
        
        public void setNegScore(int negScore) {
            this.negScore = negScore;
        }
}
