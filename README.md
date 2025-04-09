# Exploring-turnover-retention-and-growth-in-an-OSS-ecosystem


The steps of conducting our work for replication purpose:
1. Data collection
   This study used two primary datasets to examine the dynamics of developer sentiment and activity within the Gentoo open-source ecosystem. These datasets include: 

   Mailing list archive (January 2001–March 2023): Technical discussions and communications were extracted from Gentoo’s official archive website. A total of 127,584 emails and
   messages were collected. Each entry was annotated with metadata such as the timestamp, sender, recipient and subject line. This dataset was extracted, cleaned and prepared using    automated scripts, forming the basis for sentiment analysis that examined developer interactions across different phases of the project.
   * The source code used for extracting the mailing list was _GentooMonthlyMessagesScapper.py_.
   * As the output of the source code are formed into many files, we integrated all files into one file with the source code _merging all data.R_
   * We put the mailing list data into the database (the source code used was _insert_gentoo_mlists_to_masterTable-forReplication.py_
    
   Commit history dataset (July 2000–March 2023): Commit logs were retrieved directly from Gentoo's GitHub repository using the \textit{`git clone`} command. The dataset was
   structured into a database containing 5,500,779 commits. Each commit was annotated with key metadata, including committer details (e.g., name and email), timestamps, commit
   hashes and file paths. These details enabled precise mapping of developer activities to specific categories within the Gentoo ecosystem.
   The source code used for loading the commits data into the database was _GentooCommitLoading.py_
   
   
   
2. Data Preprocessing
2.1 Mailing list preprocessing
The body content of each email  was divided into individual sentences (the source code used was _NormalisedGentooMListsReport.java_) . To remove noise and irrelevant information, we applied the following cleaning steps:
    - Removed sentences prefixed by the character ‘\textgreater’, which typically denote quoted replies.
    - Stripped URLs, names or signatures and greeting phrases (e.g., “Kind Regards” and “Best Regards”).
    - Eliminated sentences containing code syntax, HTML, or XML tags.
The source code used was _NormalisedGentooMListsReport.java_.
The output of this file wasgentoo_mlists_normalised_komen.txt.
 
This process resulted in a clean dataset of 662,731 sentences, each assigned a sentiment score using the SentiStrength-SE tool. 

Source code for sentiment labeling: _ExecuteSentistrengthSE.java_; output: _results of sentimen analysis gentoo mlists.txt_. File included is _sentistrength.sh_. In order to giving the scores to each sentence, we have to compile and run the _ExecuteSentistrengthSE.java_ together with file '_gentoo_mlists_normalised_komen.txt_' as its input and its ouput as '_results of sentimen analysis gentoo mlists.txt_'. 
The '_results of sentimen analysis gentoo mlists.txt_' was put into a table in the database and the code used was _InsertingResults.java_

3. Data Analysis

The analysis phase of this study involved data aggregation and statistical techniques to investigate the relationship between developer sentiment and activity within the Gentoo ecosystem. Specifically, we analyzed both negative and positive sentiments expressed in mailing list communications and their associated activity levels in the commit dataset.

**3.1 Linking and aggregating sentiment data**
**To address RQ1**, we integrated **sentiment data** with **commit activity** by **aligning records based on timestamps (year, month, day)**. This integration allowed us to aggregate the number of positive and negative messages for each file path annually. To evaluate sentiment trends over time, we calculated the net sentiment difference (positive minus negative messages) and normalized the results using z-score normalization. Categories were ranked from most negative to most positive and the results were visualized in a heatmap and in a table (provided in the appendices).

**3.2.Sampling categories for analysis**
Given Gentoo's extensive repository of 170 categories, we selected a representative 10\% sample, resulting in 20 categories for detailed analysis. These included the ten most negative and the ten most positive categories based on sentiment scores. This approach ensured a balanced investigation of extremes in sentiment-affected components while maintaining analytical feasibility.

The code used was _hmaps-sentiment-standardnorm.R_

**Calculating workforce dynamics**
We analyzed three key workforce dynamics—retention, turnover and growth rates—within the sampled categories. 
The codes used were _analysing RR TR GR monthly-for replication.R_ and _calculating matrix corr-for replication.R_

Please see our paper for more details of the workforce dynamics.
All the dataset are available by request.
