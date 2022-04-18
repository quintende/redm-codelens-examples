# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER root

# Create users
RUN adduser demo --gecos "" --disabled-password
RUN adduser example --gecos "" --disabled-password

# Apply VS Code settings
COPY deploy-container/settings.json /home/demo/.local/share/code-server/User/settings.json

# Use nologin shell
ENV SHELL=/usr/sbin/nologin

# Fix permissions for code-server
RUN sudo chown -R demo:demo /home/demo/.local

COPY examples/ /home/example/project

# Install NodeJS && vsce
RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs
RUN sudo npm install -g vsce

# Get redm-codelens extension
RUN git clone https://github.com/quintende/redm-codelens.git /tmp/redm-codelens

# Install && package redm-codelens
RUN npm install --prefix /tmp/redm-codelens/
RUN npm run --prefix /tmp/redm-codelens/ package-web
 
# Create .vsix file
RUN cd /tmp/redm-codelens/ && vsce package

# Set user as "demo" (id: 1000)
USER 1001

# Install extension in code-server
RUN code-server --install-extension /tmp/redm-codelens/redm-codelens-0.0.1.vsix

# Port
ENV PORT=8080
ENV USER=demo

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
