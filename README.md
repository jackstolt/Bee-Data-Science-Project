# Bee-Data-Science-Project
Data science project using MaxEnt supervised machine learning method to analyze presence-only data to determine the likelihood a species will find a given location habitable.

### Python Notebook Setup:
- Create a virtual enviornment: `python -m venv <environment_name>`
- Start the virtual environtment: `source <environemnt_name>/bin/activate`
- Install required packages: `pip install -r requirements.txt`
- Host jupyter notebook server: `jupyter notebook`

### Data Processing
- Download precipitation and average temperature data from [PRISM](https://prism.oregonstate.edu/recent/)
  - Download whichever data suits your intended analysis
- Convert `.bil` files to `.asc` via `bil_to_asc.sh` script
  - example: `./bil_to_asc.sh PRISM_ppt PRISM_asc`
- Depending on downloaded format if `.asc` files format doesn't match use `super_warp_asc.sh` to translate to same sizes
  - MaxEnt should warn if `.asc` files are not identical which is required for the software to run
  - `super_warp_asc.sh` script has hardcoded resizing values which may need to be altered depending on usecase

### Maxent Running
- Download `maxent.jar` and install Java 17 via `sudo apt install openjdk-17-jdk`
- Run with desired inputs: `java -mx<memory_setting> -jar maxent.jar samplesfile=maxent_data_full_train.csv environmentallayers=PRISM_asc outputdirectory=full_maxent_results`
  - `memory_setting`: how much memory you would like to devote to the program (i.e. 512m, 1g, 4g)
  - `samplefiles`: your sample training csv data
  - `environmentallayers`: the directory with the compiled `.asc` environmental layer data
  - `outputdirectory`: directory where maxent outputs modeling results
- By opening settings the `Test sample file` field can be set to the desired test file

#### Citations
Bee and Insect Dataset
- Droege S, Maffei C (2025). Insect Species Occurrence Data from Multiple Projects Worldwide with Focus on Bees and Wasps in North America. Version 1.25. United States Geological Survey. Sampling event dataset https://doi.org/10.15468/6autvb accessed via GBIF.org on 2025-04-27.

Environmental Precipitation and Average Temperature Layer Data
- PRISM Group, Oregon State University, https://prism.oregonstate.edu, data created 4 Feb 2024, accessed 24 Apr 2024.
