# Exploring-turnover-retention-and-growth-in-an-OSS-ecosystem
The interplay between developer sentiment and workforce dynamics within the Gentoo ecosystem. Specifically, it aims to (1) compare workforce metrics between sentiment-positive and sentiment-negative components, (2) examine temporal trends across distinct phases and (3) analyse the influence of these dynamics on software stability.


The steps of conducting our work for replication purpose:
1. Data collection
   This study used two primary datasets to examine the dynamics of developer sentiment and activity within the Gentoo open-source ecosystem. These datasets include: 

   Mailing list archive (January 2001–March 2023): Technical discussions and communications were extracted from Gentoo’s official archive website. A total of 127,584 emails and
   messages were collected. Each entry was annotated with metadata such as the timestamp, sender, recipient and subject line. This dataset was extracted, cleaned and prepared using    automated scripts, forming the basis for sentiment analysis that examined developer interactions across different phases of the project.
    
   Commit history dataset (July 2000–March 2023): Commit logs were retrieved directly from Gentoo's GitHub repository using the \textit{`git clone`} command. The dataset was
   structured into a database containing 5,500,779 commits. Each commit was annotated with key metadata, including committer details (e.g., name and email), timestamps, commit
   hashes and file paths. These details enabled precise mapping of developer activities to specific categories within the Gentoo ecosystem.

   The mailing list archive and commit history were integrated to enable a general analysis of developer sentiment and its relationship with activity patterns. This integration
   relied on consistent metadata, including email addresses and timestamps, allowing the linkage of sentiment data with technical contributions.

   The mailing list data served as the primary source for sentiment analysis, while the commit history dataset was used to quantify the developer turnover, retention and growth
   rates. Together, these datasets provided a valuable resource for examining sentiment-affected components, enabling longitudinal insights into the evolving dynamics of the Gentoo    ecosystem.

   All the dataset and codes are available by request.
   
2. Data Preprocessing

   Prior to analysis, both the mailing list and commit datasets underwent extensive preprocessing to ensure accuracy and consistency. 

2.1 Mailing list preprocessing
The content of each email from the mailing list dataset was extracted and divided into individual sentences. To remove noise and irrelevant information, we applied the following cleaning steps:
    - Removed sentences prefixed by the character ‘\textgreater’, which typically denote quoted replies.
    - Stripped URLs, names or signatures and greeting phrases (e.g., “Kind Regards” and “Best Regards”).
    - Eliminated sentences containing code syntax, HTML, or XML tags.
This process resulted in a clean dataset of 662,731 sentences, each assigned a sentiment score using the SentiStrength-SE tool. These sentiment-annotated sentences were stored in a separate sentiment table to facilitate subsequent analysis.

2.2 Integration of mailing list and commit data
To address the research questions (RQ1-RQ2), it was essential to link sentiment data from the mailing list with commit data from GitHub. This required resolving inconsistencies in developer identifiers, as many developers used multiple email addresses across datasets. The following standardization steps were applied:
    - Unified email addresses by selecting a primary address for each developer, ensuring consistent mappings between sentiment and commit data.
    - For email addresses lacking explicit names, derived names from the account identifiers within the email addresses.
    - Standardized developer names across multiple formats, adopting a single canonical format for consistency.

After these preprocessing steps, each developer's email and name were consistently represented in both datasets, enabling accurate linkage. Additionally, file path names from the commit dataset were preprocessed to extract \textit{category} names, ensuring compatibility with sentiment-based analysis.

These preprocessing steps were critical for linking sentiment-driven developer interactions with commit-based activity metrics, forming the basis for the study’s investigation of workforce dynamics and sentiment-affected components.

3. Data Analysis

The analysis phase of this study involved data aggregation and statistical techniques to investigate the relationship between developer sentiment and activity within the Gentoo ecosystem. Specifically, we analyzed both negative and positive sentiments expressed in mailing list communications and their associated activity levels in the commit dataset.

**3.1 Linking and aggregating sentiment data**
**To address RQ1**, we integrated **sentiment data** with **commit activity** by **aligning records based on timestamps (year, month, day)**. This integration allowed us to aggregate the number of positive and negative messages for each file path annually. To evaluate sentiment trends over time, we calculated the net sentiment difference (positive minus negative messages) and normalized the results using z-score normalization. Categories were ranked from most negative to most positive and the results were visualized in a heatmap and in a table (provided in the appendices).

**3.2.Sampling categories for analysis**
Given Gentoo's extensive repository of 170 categories, we selected a representative 10\% sample, resulting in 20 categories for detailed analysis. These included the ten most negative and the ten most positive categories based on sentiment scores. This approach ensured a balanced investigation of extremes in sentiment-affected components while maintaining analytical feasibility.

**Calculating workforce dynamics**
We analyzed three key workforce dynamics—retention, turnover and growth rates—within the sampled categories. Please see our paper for more details of the workforce dynamics.
