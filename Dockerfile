FROM debian:12-slim

RUN apt-get update

RUN apt-get -y install curl emacs git unzip

RUN apt-get -y install python3 \
 && apt-get -y install python3-pip \
 && apt-get -y install python3-venv

# AWS CLI:
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && unzip awscliv2.zip \
 && ./aws/install

# build ECCO Dataset Production client in a virtual environment (debian
# requirement):
WORKDIR ecco_dataset_production
COPY ./processing/pyproject.toml .
COPY ./processing/src/ecco_dataset_production ./src/ecco_dataset_production
RUN /bin/bash -c '/usr/bin/env python3 -m venv ~/venvs/ecco_dataset_production'
RUN /bin/bash -c 'source ~/venvs/ecco_dataset_production/bin/activate && pip install . '

# launch virtual environment and return shell prompt:
CMD /bin/bash -c 'source ~/venvs/ecco_dataset_production/bin/activate && /bin/bash'
