from random import betavariate
import pandas as pd
import pymysql.cursors
from alphabet_detector import AlphabetDetector
from datetime import datetime
import time
ad = AlphabetDetector()


data = pd.read_csv ('/workdir/files/gentoo_mlists_all.csv')
df = pd.DataFrame (data, columns= ['From..Name.','From..Email.','To', 'CC', 'Subject','Date', 'Message.Id', 'Reply.to', 'Message.Body'])
#df.dropna(subset=['From..Name.','From..Email.','To', 'CC', 'Subject','Date', 'Message.Id', 'Reply.to', 'Message.Body'], inplace=True)

#print(df.loc[1:10, ])

connection = pymysql.connect(host='localhost',
                             user = 'admin',
                             port = 3306,
                             password = 'Admin@123',
                             db='mlstats_gentoo',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

try:
    format = '%a, %d %b %Y %H:%M:%S'
    #format = '%d/%m/%Y %H:%M'
    for ind in df.index:
        if len(str(df['Reply.to'][ind])) == 3:
            df['Reply.to'][ind] = None
        #if len(str(df['Reply.to'][ind])) > 255:
        #    continue
        if len(str(df['From..Name.'][ind])) == 3:
            df['From..Name.'][ind] = None
        if len(str(df['CC'][ind])) == 3:
            df['CC'][ind] = None
        #if len(str(df['CC'][ind])) > 255:
        #    continue
        if len(str(df['Message.Id'][ind])) == 3:
            df['Message.Id'][ind] = None
        if len(str(df['From..Email.'][ind])) == 3:
            df['From..Email.'][ind] = None
        if len(str(df['To'][ind])) == 3:
            df['To'][ind] = None
        #if len(str(df['To'][ind])) > 255:
        #    continue    
        if len(str(df['Subject'][ind])) == 3:
            df['Subject'][ind] = None
        #if len(str(df['Subject'][ind])) > 255:
        #    continue 
        if len(str(df['Message.Body'][ind])) == 3:
            df['Message.Body'][ind] = None             
        with connection.cursor()as cursor:
            cursor.execute('SET NAMES utf8mb4;')
            cursor.execute('SET CHARACTER SET utf8mb4;')
            cursor.execute('SET character_set_connection=utf8mb4;')
#            print(len(str(df['Message.Id'][ind])))
            if (str(df['Message.Id'][ind]) == "nan"):
                continue
            if ad.is_latin(str(df['Message.Id'][ind])) == False:
                continue
            sqlQuery = "INSERT INTO master_gentoo(name, email, to_email, cc, subject, date_sent,\
                                message_id, reply_to, message_body) \
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
            cursor.execute(sqlQuery, \
                (df['From..Name.'][ind], df['From..Email.'][ind], df['To'][ind], df['CC'][ind], df['Subject'][ind]\
                    , datetime.strptime(df['Date'][ind], format), df['Message.Id'][ind], df['Reply.to'][ind], df['Message.Body'][ind]))
            
        connection.commit()  
        print("insert")
finally:
    connection.close()