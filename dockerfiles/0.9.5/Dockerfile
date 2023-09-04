# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

## The buid from the base of minimal-notebook, based on python 3.8.8
## Modified by Dr. Hu Chuan-Peng, Nanjing Normal University, Nanjing, China.

## In this version, jupyter lab and jupyter have higher version:
# jupyterlab - 3.0.14
# jupyter_client - 6.1.12
# jupyter_core - 4.7.1
## Which means that some extension for plotting in jupyter should be upgraded too:
# ipympl >= 0.8
# matplotlib >= 3.3.1
# ipywidgets >= 0.76
# jupyter_widget *
#  
## Also note, I removed ipyparallel and used p_tqdm for parallel processing

ARG BASE_CONTAINER=jupyter/minimal-notebook:python-3.8.8
FROM $BASE_CONTAINER

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"

USER root

# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends ffmpeg dvipng && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Install Python 3 packages
RUN conda install --quiet --yes \
    'arviz=0.11.4' \
    'beautifulsoup4=4.9.*' \
    'conda-forge::blas=*=openblas' \
    'bokeh=2.4.*' \
    'bottleneck=1.3.*' \
    'cloudpickle=2.1.*' \
    'cython=0.29.*' \
    'dask=2.15.*' \
    'dill=0.3.*' \
    'h5py=2.10.*' \
    'hdf5=1.10.*' \
    'ipywidgets=7.6.*' \
    'ipympl=0.8.*' \
    'jupyter_bokeh' \
    'jupyterlab_widgets' \
    'matplotlib-base=3.5.*' \
    # numba update to 0.49 fails resolving deps.
    'numba=0.55.*' \
    'numexpr=2.7.*' \
    'pandas=1.0.5' \
    'patsy=0.5.*' \
    'protobuf=3.11.*' \
    'pytables=3.6.*' \
    'scikit-image=0.16.*' \
    'scikit-learn=1.1.*' \
    'scipy=1.4.*' \
    'seaborn=0.11.*' \
    'sqlalchemy=1.3.*' \
    'statsmodels=0.13.*' \
    'sympy=1.5.*' \
    'vincent=0.4.*' \
    'widgetsnbextension=3.5.*'\
    'xlrd=1.2.*' \
    # 'ipyparallel=6.3.0' \
    'pymc=2.3.8' \
    'git' \
    'mkl-service' \
    && \
    conda clean --all -f -y && \
    fix-permissions "/home/${NB_USER}"

# conda install --channel=numba llvmlite
# pip install sparse
# conda install -c conda-forge python-graphviz

# USER root
# RUN jupyter notebook --generate-config -y
    
USER $NB_UID
RUN pip install --upgrade pip && \
    # update pillow for compatibility
    pip install --no-cache-dir 'pillow==8.4' && \
    # install plotly and its chart studio extension
    pip install --no-cache-dir 'chart_studio==1.1.0' && \
    pip install --no-cache-dir 'plotly==4.14.3' && \
    pip install --no-cache-dir 'cufflinks==0.17.3' && \
    # install ptitprince for raincloud plot in python
    pip install --no-cache-dir 'ptitprince==0.2.*' && \
    pip install --no-cache-dir 'p_tqdm' && \
    fix-permissions "/home/${NB_USER}"

# install kabuki and hddm from Github
RUN pip install --no-cache-dir git+https://github.com/hddm-devs/kabuki && \
    pip install --no-cache-dir git+https://github.com/hddm-devs/hddm.git@1bb6b0e25b992b56783bc96437f220727c9f1e02 && \
    fix-permissions "/home/${NB_USER}"

# Install pymc3 after install hddm to avoid compatibility issue.
RUN pip install --no-cache-dir 'pymc3==3.11.*' && \
    pip install --no-cache-dir 'bambi==0.9.*' && \
    pip install --no-cache-dir 'paranoid-scientist' && \
    pip install --no-cache-dir 'pyddm' && \
    fix-permissions "/home/${NB_USER}"

# Install PyTorch, CPU-only
RUN conda install -c pytorch --quiet --yes \
    'pytorch=1.7.0' \
    'torchvision=0.8.0' \
    'torchaudio=0.7.0' \
    'cpuonly' \
    && \
    conda clean --all -f -y && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" &&\
     fix-permissions "/home/${NB_USER}"

## Activate ipywidgets extension
    # Activate ipywidgets extension in the environment that runs the notebook server
USER $NB_UID

# Check compatibilities of jupyterlab-manager:
# https://npm.io/package/@jupyter-widgets/jupyterlab-manager
# # compatibility with bokeh: https://www.npmjs.com/package/@bokeh/jupyter_bokeh
# # compatibility with matplotlib: https://www.npmjs.com/package/jupyter-matplotlib
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    # jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # jupyter labextension install nbdime-jupyterlab --no-build && \
    # jupyter labextension install bqplot --no-build && \
    # jupyter labextension install @jupyterlab/vega3-extension --no-build && \
    # jupyter labextension install @jupyterlab/git --no-build && \
    # jupyter labextension install @jupyterlab/hub-extension --no-build && \
    # jupyter labextension install jupyterlab_tensorboard --no-build && \
    # jupyter labextension install jupyterlab-kernelspy --no-build && \
    # jupyter labextension install @jupyterlab/plotly-extension --no-build && \
    # jupyter labextension install jupyterlab-chart-editor --no-build && \
    # jupyter labextension install plotlywidget --no-build && \
    # jupyter labextension install @jupyterlab/latex --no-build && \
    # jupyter labextension install @jupyterlab/server-proxy &&\
    jupyter labextension install jupyter-matplotlib --no-build && \
    # jupyter labextension install jupyterlab-drawio --no-build && \
    # jupyter labextension install jupyter-leaflet --no-build && \
    # jupyter labextension install qgrid --no-build && \
    jupyter lab build && \
        jupyter lab clean && \
        jlpm cache clean && \
        npm cache clean --force && \
        rm -rf "/home/${NB_USER}/.cache/yarn" && \
        rm -rf "/home/${NB_USER}/.node-gyp" && \
    fix-permissions "/home/${NB_USER}"
        
    # Activate ipyparallel extension in the enviroment
    # ipcluster nbextension enable && \
    # Also activate ipywidgets extension for JupyterLab
    # jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    # jupyter labextension install jupyter-matplotlib@^0.10.* --no-build && \
    # jupyter lab build --dev-build=False --minimize=False -y && \
    # jupyter lab clean -y && \
    # npm cache clean --force && \
    # fix-permissions "${CONDA_DIR}" &&\
    # rm -rf "/home/${NB_USER}/.cache/yarn" && \
    # rm -rf "/home/${NB_USER}/.node-gyp" && \
    # fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME

# # Change the configuration of ipyparallel
# RUN sed -i  "/# Configuration file for jupyter-notebook./a c.NotebookApp.server_extensions.append('ipyparallel.nbextension')"  /home/jovyan/.jupyter/jupyter_notebook_config.py
	
# Create a folder for example
RUN mkdir /home/$NB_USER/example && \
   fix-permissions /home/$NB_USER

# Copy example data and scripts to the example folder
COPY /example/HDDM_official_tutorial_reproduced.ipynb /home/${NB_USER}/example
COPY /example/LAN_Tutorial_reproduced.ipynb /home/${NB_USER}/example
#RUN ipcluster start -n 2
#RUN ipython profile create --parallel --profile=myprofile
