# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# This Dockerfile is for DDM tutorial
# The buid from the base of scipy-notebook, based on python 3.8

FROM jupyter/scipy-notebook:x86_64-python-3.8 AS amd64

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"

USER root

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y apt-utils && \
  apt-get install -y build-essential gcc gfortran && \
  apt-get install -y --no-install-recommends apt-utils ffmpeg dvipng && \
  rm -rf /var/lib/apt/lists/*

USER $NB_UID

# uinstall pymc 5 to avoid conflict:
RUN pip uninstall --no-cache-dir numpy -y && \
  fix-permissions "/home/${NB_USER}"

USER $NB_UID
RUN pip install --upgrade pip && \
  # it must be numpy 1.23 other than 1.22 or 1.24. 1.22 incompatible with ssms; and 1.24 incompatible with pymc
  pip install 'numpy==1.23.*'  -i https://pypi.tuna.tsinghua.edu.cn/simple && \
  pip install 'pandas==2.0.1'  -i https://pypi.tuna.tsinghua.edu.cn/simple && \
  pip install 'plotly==4.14.3' -i https://pypi.tuna.tsinghua.edu.cn/simple && \
  pip install 'cufflinks==0.17.3' -i https://pypi.tuna.tsinghua.edu.cn/simple  && \
  # install ptitprince for raincloud plot in python
  pip install 'ptitprince==0.2.*' -i https://pypi.tuna.tsinghua.edu.cn/simple  && \
  pip install 'p_tqdm'  -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install 'arviz==0.14.0' -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN pip install --no-cache-dir torch==1.9.0 -i https://pypi.tuna.tsinghua.edu.cn/simple && \
  fix-permissions "/home/${NB_USER}"

# Customized core packages that use hddm dependencies
RUN pip install pip install --no-cache-dir git+https://gitee.com/epool/pymc2 && \
  # pip install --no-cache-dir git+https://github.com/hcp4715/pymc2 && \
  pip install --no-cache-dir git+https://gitee.com/epool/kabuki && \ 
  pip install --no-cache-dir git+https://gitee.com/epool/ssm-simulators -i https://pypi.tuna.tsinghua.edu.cn/simple && \ 
  pip install --no-cache-dir git+https://gitee.com/epool/hddm && \
  fix-permissions "/home/${NB_USER}"


# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" &&\
  fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME

# Copy example data and scripts to the example folder
RUN mkdir /home/$NB_USER/OfficialTutorials && \
  rm -r /home/$NB_USER/work && \
  fix-permissions /home/$NB_USER


COPY /dockerHDDM_tutorial/dockerHDDM_quick_view.ipynb /home/${NB_USER}
COPY /dockerHDDM_tutorial/dockerHDDM_workflow.ipynb /home/${NB_USER}
COPY /OfficialTutorial/HDDM_Basic_Tutorial.ipynb /home/${NB_USER}OfficialTutorials
COPY /OfficialTutorial/HDDM_Regression_Stimcoding.ipynb /home/${NB_USER}OfficialTutorials
COPY /OfficialTutorial/Posterior_Predictive_Checks.ipynb /home/${NB_USER}OfficialTutorials
COPY /OfficialTutorial/LAN_Tutorial.ipynb /home/${NB_USER}OfficialTutorials

FROM jupyter/scipy-notebook:aarch64-python-3.8 AS arm64

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"

USER root

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y apt-utils && \
  apt-get install -y build-essential&& \
  apt-get install -y --no-install-recommends gcc-aarch64-linux-gnu && \
  apt-get install -y --no-install-recommends g++-aarch64-linux-gnu && \
  apt-get install -y gfortran && \
  apt-get install -y libatlas-base-dev && \
  apt-get install -y libopenblas-dev && \
  apt-get install -y liblapack-dev && \
  apt-get install -y pkg-config && \
  apt-get install -y --no-install-recommends ffmpeg dvipng && \
  rm -rf /var/lib/apt/lists/*

# set the env variables
RUN export CC=aarch64-linux-gnu-gcc &&\
  export CXX=aarch64-linux-gnu-g++ &&\
  export LD=aarch64-linux-gnu-ld &&\
  export AR=aarch64-linux-gnu-ar &&\
  export CROSS_COMPILE=aarch64-linux-gnu-

USER $NB_UID

# Install Python 3 packages
RUN conda install --quiet --yes \
  'git' \
  'jupyter_bokeh' \
  && \
  conda clean --all -f -y && \
  fix-permissions "/home/${NB_USER}"

# conda install -c conda-forge python-graphviz
RUN conda install -c conda-forge --quiet --yes \
  'python-graphviz' \
  'h5py' \
  'hdf5' \
  'netcdf4' \
  && \
  conda clean --all -f -y && \
  fix-permissions "/home/${NB_USER}"

# uinstall pymc 5 to avoid conflict:
RUN pip uninstall --no-cache-dir pymc -y && \
  pip uninstall --no-cache-dir pandas -y && \
  fix-permissions "/home/${NB_USER}"

USER $NB_UID

RUN pip install --upgrade pip && \
  pip install --no-cache-dir 'plotly==4.14.3' && \
  pip install --no-cache-dir 'cufflinks==0.17.3' && \
  # install ptitprince for raincloud plot in python
  pip install --no-cache-dir 'ptitprince==0.2.*' && \
  pip install --no-cache-dir 'p_tqdm'

RUN pip install --no-cache-dir torch==1.9.0 -i https://pypi.tuna.tsinghua.edu.cn/simple && \
  fix-permissions "/home/${NB_USER}"

# Customized core packages that use hddm dependencies
RUN pip install --no-cache-dir git+https://github.com/arviz-devs/arviz.git@2c50144d0b804078a6deebc7a861e583fe8d40c6
RUN pip install --no-cache-dir git+https://gitee.com/epool/pymc2 && \
  pip install --no-cache-dir git+https://gitee.com/epool/kabuki && \ 
  pip install --no-cache-dir git+https://gitee.com/epool/ssm-simulators -i https://pypi.tuna.tsinghua.edu.cn/simple && \ 
  pip install --no-cache-dir git+https://gitee.com/epool/hddm && \
  fix-permissions "/home/${NB_USER}"


# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" &&\
  fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME

# Copy example data and scripts to the example folder
RUN mkdir /home/$NB_USER/OfficialTutorials && \
  rm -r /home/$NB_USER/work && \
  fix-permissions /home/$NB_USER


COPY /dockerHDDM_tutorial/dockerHDDM_quick_view.ipynb /home/${NB_USER}
COPY /dockerHDDM_tutorial/dockerHDDM_workflow.ipynb /home/${NB_USER}
COPY /OfficialTutorial/HDDM_Basic_Tutorial.ipynb /home/${NB_USER}OfficialTutorials
COPY /OfficialTutorial/HDDM_Regression_Stimcoding.ipynb /home/${NB_USER}OfficialTutorials
COPY /OfficialTutorial/Posterior_Predictive_Checks.ipynb /home/${NB_USER}OfficialTutorials
COPY /OfficialTutorial/LAN_Tutorial.ipynb /home/${NB_USER}OfficialTutorials