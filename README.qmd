# Robinson Preserve Sportfish Tagging Project: Website README and instructions

This repository contains code required to produce the website for the Robinson Preserve Sportfish Tagging Project. The website is built using [Quarto](https://quarto.org/) and hosted through the Tampa Bay Estuary Program using [GitHub Pages](https://pages.github.com/). All edits to the website must be made through Quarto; if an edit to the website is required, please submit an Issue through the GitHub interface, and a website administrator will address it as required.

## Instructions for website administration

To make changes and edits to the website, you will need to have a GitHub account. Go to [GitHub.com](https://github.com) to create an account. You will also need to be added as an Admin to the GitHub repository. Have the current admin go to <https://github.com/tbep-tech/robinson-sport-fish/settings/access> to add you as a collaborator with Admin privileges. You will now have the ability to push changes to the website.

In order to render this website, you need to have the following programs installed on the computer:

-   [Git](https://git-scm.com/)

-   [R Statistical Software](https://cran.r-project.org/)

-   [RStudio IDE](https://www.rstudio.com/products/rstudio/download/#download)

-   [Quarto](https://quarto.org/docs/get-started/) (packaged with the latest versions of RStudio)

-   [Github Desktop](https://github.com/apps/desktop)

The website render requires several R packages to be installed on the user's machine. These packages will be installed automatically if the user does not already have them installed.

### Setting up your file structure

The GitHub repository contains most of the files necessary for rendering the website; however, several files must be stored outside of the repository for privacy and file size limitations. Prior to cloning the GitHub repository, find the appropriate folder on the FWC FIMP network folder (`\\fwc-spfs1\fishbio\FIMP\RobinsonPreserve\Acoustics\Website`) and copy the `Robinson Preserve` folder from the network folder to your local machine.

### Cloning the repository

If this is your first time administrating the Robinson Preserve website, you will first need to clone the repository onto your local machine. Open Github Desktop, sign in if needed, open the File dropdown menu, and select "Clone Repository". Enter "tbep-tech/robinson-sport-fish" in the repository section (if you have been added as a collaborator, the repository may pop up under Your Repositories). In the Local Path, navigate to the Robinson Preserve folder that you copied from the FIMP network folder. When you are ready, select Clone. The application will download the files into a separate folder inside the Robinson Preserve folder with the name of the repository. This folder contains an Rproj file called `Robinson Preserve.Rproj`. Open this file in RStudio, and the repository will be ready to update.

### Google Analytics setup

The website uses Google Analytics to report data on the number of users and average engagement of the website for grant reporting purposes. If the admin of the website changes, the Google Analytics will need to be re-assigned to a Google account for the new admin. To set up Google Analytics, go to [analytics.google.com](https://analytics.google.com), sign in with an active Google account, and proceed through the instructions to set up an analytics account. Once an account has been set up, create a "property" (referring to the website to track). Proceed through the options until you get to the "Set up a Google tag" step. Quarto requires the tag number to be copied into the `_quarto.yml` file, and the rendering process adds the tag to all pages. The tag number can be found in the code provided on the "Set up a Google tag" page; it will start with a 'G-' and contain a series of alphanumeric characters. Copy only this tag (with quotation marks) into the `_quarto.yml` file in the appropriate location. Render and publish the website using the instructions below, and the analytics tag will be applied to each section of the final website.

### Post-data-download website updates

#### Updating the downloaded receiver data file

The `AcousticData_Collating.R` file is an R script that will automatically collect downloaded CSV files that have been added to the FIMaster Robinson acoustics folder (`//fwc-spfs1/FIMaster/Data/RP_acoustics/AcousticReceiverLogs`) into a single CSV file. This file is used to update the pop-out charts on the data map visualization of the website. Prior to updating the website, open this file in RStudio from the Robinson Preserve Rproject and click the "Source" button in the top right-hand corner. This will reproduce the `AllAcoustic.csv` file in the Robinson Preserve folder. This code also produces a figure that can be manually inspected for updating number on the Data page.

#### Updating numbers on the main page

The `index.qmd` file contains the code and text for rendering the main page of the website. After a data download, the numbers below the icons on the main page will need to be updated. There are two sections that contain the same numbers: one for the website in light mode (dark icons), and one for the website in dark mode (dark icons). Find the "Data Downloads" part in each section, and increase this number to indicate the number of data downloads that have occurred. Next, open the `AllAcoustic.csv` file and find the number of rows; this is the total number of detections that have been counted across all receivers and all downloads. Find the "Detections" part of each icon section on the index.qmd file, and update the numbers. You can round to the nearest tenth of a million.

#### Updating numbers on the Data page

The `data.qmd` file contains the code and text for rendering the Data section of the website. After a data download, the number in the text will need to be manually updated. Manually inspect the figure produced when running the `AcousticData_Collating.R` script to obtain the required numbers. Update the text as needed. Note that the "most recently heard from" fish are those that were heard from between the previous data download and the current one.

#### Adding a post and timeline item to the Updates page

To add an update post after a download, open the `updates` folder in the repository and make a copy of the latest download{x}.qmd file. Change the file name to reflect how many data downloads have been completed. Open the file and change the title, author, and date of the data download in the header. Update the text to reflect the proper numbers of additional detections and how many fish were detected. Update the remaining text to add any issues, curiosities, etc. associated with the data download. If any pictures were taken in the field (of interesting occurrences, fish, field staff, etc), copy the picture into the `images` folder inside the `updates` folder, and add them into the quarto file using the Insert -\> Figure/Image dropdown menu. Assign a descriptive caption to the image. Save the .qmd file, and navigate back to the main repository folder.

Open the `updates.qmd` file. Scroll down to the last row of the `timeItems` data frame code. Copy the last `add_row` command (three lines), add a `%>%` to the end of the last row, paste the three lines that were copied onto the end, and change the values for id, content, and start. The id is a unique identifier for a given update. Assign it the same name as the .qmd update file. The `content` column contains an HTML-coded link to the update post; this will always be under `/robinson-sport-fish/updates/`. The link should be the name of the quarto file added for the update, but with `.html` instead of `.qmd`. The text that will show up in the timeline (linked to the update file) comes in between the `>` and `<` of the html code. Assign the `start` column to the date the download was completed. See the previous lines in the code for examples of how to enter these values.

### Other website updates

If a project update that isn't related to a data download occurs (e.g., outreach event, poster/presentation, conclusion of project), add a post to the `updates` folder as before. Make sure the name of the .qmd file, the title of the post, and the text of the post are descriptive. Add an update to the timeline in the `update.qmd` file with the date of the update and an id and descriptor that correspond to the type of update. If there is an update that does not warrant a full post, add the update to the timeline but ignore the HTML code in the `content` column; simply add the event as a normal text string (see the "start" item for an example).

### Render the website locally

Open the `Render.R` file in the repository folder. This file is where all the changes that were made to the Quarto files will be translated from Quarto into HTML for the website. Also note that this is where any packages that need to be installed are checked for and installed automatically. To render the website, click the Source button in the top right hand corner of the `Render.R` file. If this is the first time rendering the website, the packages will install first. If any errors occur during package installation, the website will not render. If this occurs, address the errors (usually any errors at this stage are due to dependencies; inspect the output text from package installation and install any required dependencies). The Quarto website will then render. **This will take a while, potentially several hours**. Once the render is complete, a preview of the website will open. Click on any of the pages that were updated to make sure they rendered properly.

### Push changes to GitHub

Open GitHub Desktop and use the interface to navigate to the repository. All changes to both the Quarto files and the HTML files should show up in the left-hand column. Confirm that these changes are indeed correct, enter a Summary description (for an data download, a simple "Updated website for nth data download" should suffice), and hit the "Commit to main" button. After the commit is processed, select the "Push origin" button at the top of the GitHub Desktop window. This will push the updated website up to GitHub. GitHub Pages will then update the website at its appropriate URL (this may take a minute or so). Open the website URL, and ensure that the changes made are reflected in the final website.
