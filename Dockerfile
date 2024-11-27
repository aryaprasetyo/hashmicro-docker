# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and dependencies for Python 3.8, Odoo, and PostgreSQL
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository universe \
    && apt-get update && apt-get install -y \
    python3.8 python3.8-dev python3.8-distutils python3-pip \
    git \
    wget \
    curl \
    libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev build-essential \
    libssl-dev libffi-dev libjpeg-dev libpq-dev libpng-dev xz-utils \
    && apt-get clean

# Set Python 3.8 as the default python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Install pip for Python 3.8
RUN python3.8 -m pip install --upgrade pip

# Install Odoo dependencies
# RUN pip3 install -r https://raw.githubusercontent.com/odoo/odoo/14.0/requirements.txt

# Install wkhtmltopdf (required for printing reports in Odoo)
RUN apt-get install -y wkhtmltopdf

# Create directory for Odoo and set permissions
RUN mkdir -p /opt/odoo
#  && chown -R odoo: /opt/odoo

# Set working directory
WORKDIR /opt/odoo

# Clone the Odoo 14 source code from GitHub
RUN git clone --depth=1 --branch=14.0 https://www.github.com/odoo/odoo /opt/odoo

# Copy the Odoo configuration file
# COPY ./odoo.conf /etc/odoo/odoo.conf

# Set user to root
USER root

# install EQUIP3 dependencies
RUN apt-get install -y --force-yes libpq5>=15~rc2-1
RUN apt-get install -y --force-yes python-dev
RUN apt-get install -y --force-yes python3-dev
RUN apt-get install -y --force-yes libdbus-1-3 libdbus-1-dev glib-2.0
RUN apt-get install -y --force-yes libsasl2-dev || true
RUN apt-get install -y --force-yes libldap2-dev || true
RUN apt-get install -y --force-yes python3-pandas
RUN apt-get install -y --force-yes pkg-config

RUN pip3 install --upgrade wheel
RUN pip3 install --upgrade setuptools
RUN pip3 install --upgrade importlib-metadata
RUN pip3 install --upgrade packaging

COPY ./req.txt .
RUN pip3 install --user --use-deprecated=legacy-resolver --ignore-installed -r req.txt        

COPY ./req2.txt /opt/odoo
RUN pip3 install --user --use-deprecated=legacy-resolver --ignore-installed -r req2.txt

COPY ./req3.txt .
RUN pip3 install --user --use-deprecated=legacy-resolver --ignore-installed -r req3.txt

COPY ./req4.txt .
RUN pip3 install --user --use-deprecated=legacy-resolver --ignore-installed -r req4.txt

RUN pip3 install --upgrade fitz 
RUN pip3 install --upgrade frontend 
RUN pip3 install --upgrade starlette 
RUN pip3 install tools

COPY ./basic/* /opt/odoo/addons/

# Set the default command to run Odoo
CMD ["./odoo-bin", "--config=/etc/odoo/odoo.conf"]
