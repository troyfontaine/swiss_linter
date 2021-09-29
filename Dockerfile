FROM alpine:3.14

# Install Dependencies
# and yamllint
RUN set -eux \
    apk update && \
    apk add --no-cache \
    bash=5.1.4-r0 \
    python3=3.9.5-r1 \
    py3-pip=20.3.4-r1 \
    bc=1.07.1-r1 \
    nodejs-current=16.6.0-r0 \
    npm=7.17.0-r0 \
    git=2.32.0-r0 \
    && pip3 install --no-cache-dir --upgrade pip==21.2.4 \
    && pip3 install --no-cache-dir yamllint==1.26.3 \
    && addgroup -S linter && adduser -S linter -G linter

# Install jsonlint
RUN npm install jsonlint@1.6.3 -g

# Copy in our helper script
# for working with jsonlint
COPY --chmod=755 jsonlint.sh /usr/bin/json

# Secure our container by swapping
# to our limited user account
USER linter

WORKDIR /tmp/lint
