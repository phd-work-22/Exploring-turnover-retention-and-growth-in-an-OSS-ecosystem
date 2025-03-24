from bs4 import BeautifulSoup
import requests
import csv
import re

regex = re.compile(r'([A-Za-z0-9]+[.-_])*[A-Za-z0-9]+@[A-Za-z0-9-]+(\.[A-Z|a-z]{2,})+')

#arcYears = ["2001","2002","2003","2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012",
#            "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022"]
#arcMonth = ["01", "02","03","04","05","06","07","08","09","10","11","12"]
arcYears = ["2022"]
arcMonth = ["07","08","09","10","11","12"]

i = 0
for wMailists in arcYears:
    j = 0
    for wwMailits in arcMonth:
        webUrl = "https://archives.gentoo.org/gentoo-dev/messages/" + arcYears[i] + "-" + arcMonth[j] +"/"
        webPage = requests.get(webUrl)
        
        navBlockSoup = BeautifulSoup(webPage.content, 'html.parser')

        navBlockList = navBlockSoup.find_all('table', class_="d-none d-sm-block")

        for nav in navBlockList:
            threadData = thread.find_all('a')

            

        for navblock in navBlockList:
            blockData = navblock.find_all('li')

            
            for blockDetail in blockData:
                print(blockDetail.get_text())
                blockLists.append(blockDetail.get_text())    
        
        k = 0
        blockLists = []
        for tabLists in blockLists:
           
            # Fill in the thread url and the csv name here
            threadUrl = "https://archives.gentoo.org/gentoo-dev/messages/" + arcYears[i] + "-" + arcMonth[j] +"/"+ tabLists[k]
            csvName = arcYears[i]+"-"+arcMonth[j]+"-"+tabLists[k]+"m.csv"
            # ========================================================================

            dataForCsv = []
            dataForCsv.append(["From (Name)", "From (Email)", "To", "CC", "Subject", "Date", "Message-Id", "Reply to","Message-Body"])

            threadPage = requests.get(threadUrl)

            threadSoup = BeautifulSoup(threadPage.content, 'html.parser')

            threadList = threadSoup.find_all('table', class_="table table-sm table-hover ag-message-table")

            for thread in threadList:
                threadData = thread.find_all('a')
                
                for threadElement in threadData:
                    messageUrl = threadElement.get('href')
                    messageUrl = messageUrl.replace("../../", "https://archives.gentoo.org/gentoo-dev/")
                    messagePage = requests.get(messageUrl)
                    print(messageUrl)
                    messageSoup = BeautifulSoup(messagePage.content, 'html.parser')

                    messageDetailArr = []

                    messageDatas = messageSoup.find_all('table', class_="table table-sm ag-header-table")
                    for messageData in messageDatas:
                        dataDetails = messageData.find_all('td')
                        
                        for dataDetail in dataDetails:
                            
                            messageDetailArr.append(dataDetail.get_text())

                    messageBody = messageSoup.find_all('table', class_="w-100")
                    messageString = ""
                    for messageBodyPart in messageBody:
                        messageBodyLine = messageBodyPart.find_all('tr', class_="ag-line")
                        for messageBodyLinePart in messageBodyLine:
                            messageBodyLineTPartText = messageBodyLinePart.find_all('td')
                            messageString = messageString + messageBodyLineTPartText[1].get_text() + "\n"

                    messageDetailArr.append(messageString)
                    

                    # Handle data different between message with 'Reply to' and message without 'Reply To'
                    # Handle data different between message with 'CC' and message without 'CC'
                    # Handle data different between message with both and without both(CC and Reply To)
                    #if len(messageDetailArr) == 7:
                    #    messageDetailArr.insert(, "")
                    if len(messageDetailArr) == 6:
                        messageDetailArr.insert(2, "")
                        messageDetailArr.insert(6, "")
                    elif len(messageDetailArr) == 7 and re.match('[^@]+@[^@]+\.[^@]+', messageDetailArr[2]):
                        messageDetailArr.insert(6, "")
                        print("contain emails")
                    elif len(messageDetailArr) == 7 and not(re.match(regex, messageDetailArr[2])):
                        messageDetailArr.insert(2, "")    

                    
                    # spliting email from name
                    nameAndEmail = []
                    if "<" in messageDetailArr[0]:            
                        nameAndEmail = messageDetailArr[0].split("<")
                        nameAndEmail[1] = nameAndEmail[1].replace(">", "")
                    elif "(" in messageDetailArr[0]:
                        nameAndEmail = messageDetailArr[0].split("(")
                        nameAndEmail[1] = nameAndEmail[1].replace(")", "")
                        tempString = nameAndEmail[0]
                        nameAndEmail[0] = nameAndEmail[1]
                        nameAndEmail[1] = tempString
                    else:
                        if "@" in messageDetailArr[0]:
                            nameAndEmail = ["", messageDetailArr[0]]
                        else:
                            nameAndEmail = [messageDetailArr[0], ""]

                    messageDetailArr[0] = nameAndEmail[0]
                    messageDetailArr.insert(1, nameAndEmail[1])

                    # Add to array for CSV
                    dataForCsv.append(messageDetailArr)



            with open(csvName, 'w', newline='', encoding="UTF-8") as csvfile:
                writer = csv.writer(csvfile)
                writer.writerows(dataForCsv)
            k = k + 1


        # print(type(testArray))
        j = j+1
    i=i+1
