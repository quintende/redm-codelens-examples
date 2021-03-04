FROM codercom/code-server:latest

USER coder

# Apply VS Code settings
COPY settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install rclone (support for remote filesystem)
RUN curl https://rclone.org/install.sh | sudo bash

# Fix permissions
RUN sudo chown -R coder:coder /home/coder/.local

# Port for railway
ENV export PORT=80

# Use our custom entrypoint script first
COPY railway-entrypoint.sh /usr/bin/railway-entrypoint.sh
ENTRYPOINT ["/usr/bin/railway-entrypoint.sh"]
