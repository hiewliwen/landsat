<br/>
<p align="center">
  <a href="https://github.com/hlw1/LANDSAT">
    <img src="https://landsat.gsfc.nasa.gov/wp-content/uploads/2021/12/Landsat_8_LDCM_Mission_Patch.png" alt="Logo" width="200" >
  </a>

  <h3 align="center">LANDSAT Satellite Imageries</h3>

  <p align="center">
    Remote Sensing Analytics with LANDSAT Satellite
    <br/>
    <br/>
    <a href="https://github.com/hiewliwen/landsat"><strong>Explore the docs »</strong></a>
    <br/>
    <br/>
    <a href="https://github.com/hiewliwen/landsat">View Demo</a>
    .
    <a href="https://github.com/hiewliwen/landsat/issues">Report Bug</a>
    .
    <a href="https://github.com/hiewliwen/landsat/issues">Request Feature</a>
  </p>
</p>

![Downloads](https://img.shields.io/github/downloads/hiewliwen/landsat/total) ![Forks](https://img.shields.io/github/forks/hiewliwen/landsat?style=social) ![Issues](https://img.shields.io/github/issues/hiewliwen/landsat) ![License](https://img.shields.io/github/license/hiewliwen/landsat) 

## Table Of Contents

* [About the Project](#about-the-project)
* [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Authors](#authors)
* [Acknowledgements](#acknowledgements)

## About The Project

<div align="center">
<img src=images/assets/LST.png alt="LST" width="500">
</div>

One of the important urban and envirnomental planning metrics is the ambient temperature which correlates to thermal comfort. However we cannot have a accurate sensing of the ambient temperature because of the sparse ambient temperature sensors installed in Singapore. 

We turn to USGS Landsat 8 satellite images to generate Land Surface Temperature (LST) maps. LST is the radiative skin temperature of the land derived from solar radiation. We use LST as a proxy to ambient temperature.

In this repository, you will find the scripts required to download, generate and stack LST maps. 

## Built With

* [Anaconda](https://anaconda.org/)
* [R Studio](https://posit.co/)

## Getting Started

### Prerequisites

###### Python Packages (in Conda)
```
conda install --file requirements.txt
```
###### R Packages (in R Studio)
|   |   |
|---|---|
| maptools     | rlist      |
| raster       | rstudioapi |
| RColorBrewer | sp         |
| rgdal        |            |
```
install.packages(c("maptools", "raster", "RColorBrewer", "rgdal", "rlist", "rstudioapi", "sp"))
```

### Installation

1. Register for an EarthExplorer account [here.](https://ers.cr.usgs.gov/register)

2. Clone the repo

```sh
git clone https://github.com/your_username_/Project-Name.git
```

3. Install Python & R packages

4. Enter your EarthExplorer credentials in `CONFIG.py`

## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

## Roadmap

See the [open issues](https://github.com/hlw1/LANDSAT/issues) for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.
* If you have suggestions for adding or removing projects, feel free to [open an issue](https://github.com/hlw1/LANDSAT/issues/new) to discuss it, or directly create a pull request after you edit the *README.md* file with necessary changes.
* Please make sure you check your spelling and grammar.
* Create individual PR for each suggestion.

### Creating A Pull Request

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See [LICENSE](https://github.com/hlw1/LANDSAT/blob/main/LICENSE.md) for more information.

## Authors

* [**HIEW Li Wen**](https://github.com/hiewliwen/)

## Acknowledgements

* [Yann Forget](https://github.com/yannforget)
