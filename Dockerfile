FROM alpine:3.23.3

# Install Dependencies
# and yamllint
RUN set -eux \
    apk update && \
    apk add --no-cache \
    build-base=0.5-r3 \
    libffi-dev=3.5.2-r0 \
    openssl-dev=3.5.5-r0 \
    bzip2-dev=1.0.8-r6 \
    zlib-dev=1.3.1-r2 \
    xz-dev=5.8.2-r0 \
    readline-dev=8.3.1-r0 \
    sqlite-dev=3.51.2-r0 \
    linux-headers=6.16.12-r0 \
    bash=5.3.3-r1 \
    python3=3.12.12-r0 \
    py3-pip=25.1.1-r1 \
    bc=1.08.2-r0 \
    curl=8.17.0-r1 \
    shadow=4.18.0-r0 \
    nodejs-current=24.9.0-r1 \
    npm=11.6.3-r0 \
    git=2.52.0-r0

# Install jsonlint
RUN npm install jsonlint@1.6.3 -g

# Copy in our helper script
# for working with jsonlint
COPY --chmod=755 jsonlint.sh /usr/bin/json

# Requires shadow package to manage users and groups
RUN addgroup -S linter && adduser -S linter -G linter \
    && chsh -s /bin/bash linter

# Secure our container by swapping
# to our limited user account
USER linter

RUN curl -fsSL https://pyenv.run | bash \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc

ENV PATH="/home/linter/.pyenv/shims:/home/linter/.pyenv/bin:$PATH"

RUN pyenv install 3.14.3 && pyenv global 3.14.3

RUN pip3 install --no-cache-dir --upgrade pip==26.0.1 \
    && pip3 install --no-cache-dir yamllint==1.38.0

WORKDIR /tmp/lint

CMD ["/bin/bash"]
