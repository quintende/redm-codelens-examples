FROM codercom/code-server:4.7.1

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

COPY deploy-container/examples/ /home/example/project

# Install wget
RUN sudo apt-get update
RUN sudo apt-get install wget

# Copy the code-server vsix to the container
RUN curl https://api.github.com/repos/quintende/redm-codelens/releases | grep -Eo '"browser_download_url": "(.*vsix\.tar\.gz)"' | grep -Eo 'https://[^\"]*' | sed -n '1p' | xargs wget -O - | tar -xz

# Set user as "demo" (id: 1001)
USER 1001

# Install extension in code-server
RUN ls | grep vsix | xargs code-server --install-extension

# Port
ENV PORT=8080
ENV USER=demo

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
