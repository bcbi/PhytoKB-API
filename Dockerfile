FROM julia:0.6.3

# ----------------------Julia web-app specific packages--------------------------------
# my packages
ADD src/install_pkgs.jl /tmp/install_pkgs.jl
RUN julia /tmp/install_pkgs.jl

# Create app directory
RUN mkdir -p /usr/bin/phytokb
WORKDIR /usr/bin/phytokb

# Bundle app source
COPY . /usr/bin/phytokb

EXPOSE 8081

CMD ["julia", "api/server.jl"]
