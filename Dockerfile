# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER root

RUN adduser demo --gecos "" --disabled-password
RUN useradd -ms /bin/bash example


# Apply VS Code settings
COPY deploy-container/settings.json /home/demo/.local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/usr/sbin/nologin


# Fix permissions for code-server
RUN sudo chown -R demo:demo /home/demo/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

RUN git clone https://github.com/quintende/redm-codelens-examples.git /home/example/project

# Install NodeJS
RUN git clone https://github.com/quintende/redm-codelens.git /tmp/redm-codelens
RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs
RUN sudo npm install -g vsce

RUN npm install --prefix /tmp/redm-codelens/
RUN npm run --prefix /tmp/redm-codelens/ package-web
 
RUN cd /tmp/redm-codelens/ && vsce package


USER 1001

RUN code-server --install-extension /tmp/redm-codelens/redm-codelens-0.0.1.vsix


# Port
ENV PORT=8080
ENV USER=demo

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
