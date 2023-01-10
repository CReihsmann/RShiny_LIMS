# **BLUE** :
#### A **B**etter **L**ims **U**ser **E**xperience
</br>

### Motivation 

To catalog tissue samples, our lab uses a LIMS (laboratory information management system) offered through **Platform for Science<sup>TM**. While the data itself is well organized, navigating and quering the site is limited and cumbersome. To address this problem I wanted to build a tool that was easy to use and gave us more options in querying and visuzalizing our database

<br>

### App Features

* **Log in**: Uses user credentials to generate metadata API call to determine access.

* **Data Retrieval**: Using the same credentials at log in, will perform another API call to retrieve the entire LIMS dataset and undergoes data wrangling and standardization. 
    * A separate API call is made between login in and data retrieval as the metadata API is quicker and allows for faster user authentication
* **Home**: 
    * Data Search tab: Individual donor search options for three types of data:
        1. Freezer location - most used so it gets its own search
        1. Assorted information - allows to search individual column information for any donor
        1. Notes - pulls past medical history, donor information, or patient chart information
    * Donor Search tab: sends API call to updatable google sheet to allow for searching of donor names in the case a researchers personal notes do not line up with the database's names 
* **Plots**:
    * Barcharts: Gives overview of some basic categories within dataset. Also allows for coloring by subgroup
    * Histograms: Choosing any numeric column, allows for the production of a histogram with adjustable bin number, filtering by category, grouping by category, and histogram layout style
* **Tables**:
    * Category tab: Column choices are based on the original column category options in the **Platform for Science<sup>TM** LIMS system. All category options include those found in **Basic Info**. Also allows for filtering based on donor, age, gender, and race.
    *Personalized tab: Allows for the construction of a personalized table. Starts with the basic columns seen when opening tabs. Can also be filtered based on donor, age, gender, and race.
