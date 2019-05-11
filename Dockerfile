FROM python:3.7.0-slim

ENV LIB="libswscale-dev \
  libtbb2 \
  libtbb-dev \
  libjpeg-dev \
  libpng-dev \
  libtiff-dev \
  libglib2.0-0 \
  libsm6 \
  libxext6 \
  libavformat-dev \
  libpq-dev \
  git"

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get install --no-install-recommends -qy $LIB \
  && apt-get clean \
  && apt-get autoclean \
  && apt-get autoremove

RUN  git clone https://github.com/Utree/photos2.git

WORKDIR /photos2

RUN python3 -m pip install -r requirements.txt

RUN rm -rf /tmp/* /var/tmp/* \
  && rm -rf /var/lib/apt/lists/* \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p uploaded_files/api_v1/images

RUN python3 manage.py migrate

CMD gunicorn --bind 0.0.0.0:$PORT project.wsgi
