# Docker Ubuntu TuG TeX Live

A docker image based on Ubuntu with a full TeX Live suite and additional packages like pygmentize to enable easy compilation of TeX files in continuous integration environments like Gitlab CI.

## How to Use the Image

Choose the correct TeX Live version you want: from 2016 to 2020.
In addition, choose your desired scheme i.e., a collection of packages.
We support all schemes that the TuG TeX Live offers.
See also the matrices below for a list of docker images and their dependencies.

If you chose your image, e.g., `philipptempel/docker-ubuntu-tug-texlive:2020-basic` you can simply use it as a docker image e.g., `docker run -t philipptempel/docker-ubuntu-tug-texlive:2020-basic` inside of which you can run any LaTeX-related compiler.
To compile using `latexmk`, just start the image and rund `latexmk <file.tex>`.
Same goes for `lualatex`, `pdflatex`, `xelatex`, and other derivatives.

In addition, you can also install additional packages if need be using `tlmgr install <package>`.



## Using the Image with GitLab CI

Use the following example `.gitlab-ci.yml`.
It is split into two targets, one running on `master` branch (job `final`) and one running on any other branch (job `draft`).
The `latexmk` call assumes that you have configured your project with a `.latexmkrc` so that the `@default_files` variable is set.
Otherwise, of course, it must be `latexmk source.tex`.
For any further adjustments of the GitLab CI configuration, please refer [to the GitLab docs](https://docs.gitlab.com/ee/ci/yaml/).

```yaml
draft:
  stage: latexmk
  image: philipptempel/docker-ubuntu-tug-texlive:latest-medium
  except:
    refs:
      - master
  script:
    - 'latexmk'
  artifacts:
    name: "${CI_PROJECT_PATH_SLUG}_${CI_COMMIT_REF_NAME}"
    paths:
      - '*.log'
      - '*.pdf'
    expire_in: 1 week

final:
  stage: latexmk
  image: philipptempel/docker-ubuntu-tug-texlive:latest-medium
  only:
    refs:
      - master
  script:
    - 'latexmk'
  artifacts:
    name: "${CI_PROJECT_PATH_SLUG}_${CI_COMMIT_REF_NAME}"
    paths:
      - '*.log'
      - '*.pdf'
    expire_in: 1 week
```


## Available Images

The `latest` tag always refers to the current year and a build that is at most 1 week old.
This way, updated packages will always be included very timely.
Older i.e., deprecated or archived versions, are also available, however, these will not be updated anymore (neither TeX Live nor the underlying ubuntu will be updated).
Every year comes in various flavors representing the different texlive schemes.
You may choose from the following images matrix

| Scheme | infraonly        | minimal        | basic        | small        | medium        | full        |
| ------ | ---------------- | -------------- | ------------ | ------------ | ------------- | ----------- |
| 2020   | latest-infraonly | latest-minimal | latest-basic | latest-small | latest-medium | latest-full |
| 2019   | 2019-infraonly   | 2019-minimal   | 2019-basic   | 2019-small   | 2019-medium   | 2019-full   |
| 2018   | 2018-infraonly   | 2018-minimal   | 2018-basic   | 2018-small   | 2018-medium   | 2018-full   |
| 2017   | 2017-infraonly   | 2017-minimal   | 2017-basic   | 2017-small   | 2017-medium   | 2017-full   |
| 2016   | 2016-infraonly   | 2016-minimal   | 2016-basic   | 2016-small   | 2016-medium   | 2016-full   |

