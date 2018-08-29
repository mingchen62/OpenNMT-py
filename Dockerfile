FROM ubuntu:16.04
RUN mkdir /src
RUN chmod -R a+w /src
COPY im2text-hw-model_acc_96.75_ppl_1.16_e13.pt /src/
COPY app.sh /src/
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*


RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \     
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install numpy pyyaml scipy mkl urllib3 requests flask flask-cors scikit-image six tqdm && \
 #    /opt/conda/bin/conda install -c soumith magma-cuda90 && \
     /opt/conda/bin/conda clean -ya 
ENV PATH /opt/conda/bin:$PATH

RUN conda install pytorch-cpu torchvision-cpu -c pytorch && /opt/conda/bin/conda clean -ya
#RUN conda remove cudatoolkit cudnn --force -c soumith && /opt/conda/bin/conda clean -ya

RUN mkdir /workspace 
WORKDIR /workspace
RUN chmod -R a+w /workspace
RUN git clone https://github.com/mingchen62/OpenNMT-py-fix && cd OpenNMT-py-fix && pip install --no-cache-dir -r requirements.txt && python setup.py install 

# Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /workspace/OpenNMT-py-fix
#Install new model
RUN cp /src/app.sh  /workspace/OpenNMT-py-fix/
RUN mkdir saved_models
RUN cp /src/im2text-hw-model_acc_96.75_ppl_1.16_e13.pt /workspace/OpenNMT-py-fix/saved_models/im2text-hw-model_acc_96.75_ppl_1.16_e13.pt
RUN mkdir temp
RUN chmod +x /workspace/OpenNMT-py-fix/app.sh
# Launch
CMD ["/workspace/OpenNMT-py-fix/app.sh"]
