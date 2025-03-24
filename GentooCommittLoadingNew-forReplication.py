from random import betavariate
from pydriller import Repository
from datetime import datetime

import pymysql.cursors
from alphabet_detector import AlphabetDetector
ad = AlphabetDetector()

connection = pymysql.connect(host='localhost',
                             user = 'admin',
                             port = 3306,
                             password = 'Admin@123',
                             db='mlstats_gentoo',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)
try:
    dt1=datetime(2022,6,9,0,0,1)
    dt2=datetime(2023,3,31,23,59,59)
    #for commit in Repository ('/mnt/D/gentooCommitHistory/historical').traverse_commits():
    for commit in Repository ('/mnt/D/gentooCommitsNew/gentoo', since=dt1, to=dt2).traverse_commits():
        for modifiedFile in commit.modified_files:
            with connection.cursor()as cursor:
                cursor.execute('SET NAMES utf8;')
                cursor.execute('SET CHARACTER SET utf8;')
                cursor.execute('SET character_set_connection=utf8;')
                sqlQuery = "INSERT IGNORE INTO developers_commits(hash, email, name, author_date, committer_email, committer_date, filename, old_path, new_path) \
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)  "
                cursor.execute(sqlQuery, \
                    (commit.hash, commit.author.email, commit.author.name, str(commit.committer_date), 
                    commit.committer.email, str(commit.committer_date), modifiedFile.filename, modifiedFile.old_path, modifiedFile.new_path))
            connection.commit()  
finally:
    connection.close()