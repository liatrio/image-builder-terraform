FROM alpine:3.16

RUN apk add --no-cache \
    git \
    curl \
    unzip \
    openssh-client \
    make \
    musl-dev \
    go

ARG GOLANG_VERSION=1.18
RUN wget https://dl.google.com/go/go$GOLANG_VERSION.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -m 0777 ${GOPATH} ${GOPATH}/src ${GOPATH}/bin

WORKDIR /tmp/
ENV TERRAFORM_VERSION 1.2.5
COPY sig/hashicorp.asc /tmp/.
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp/
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS /tmp/
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig /tmp/

RUN apk --update add --virtual verify gpgme \
 && gpg --import hashicorp.asc \
 && gpg --verify /tmp/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig \
 && cat terraform_${TERRAFORM_VERSION}_SHA256SUMS | grep linux_amd64 | sha256sum -c \
 && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && chmod +x terraform \
 && mv terraform /usr/bin \
 && apk del verify \
 && rm -rf /tmp/* \
 && rm -rf /var/cache/apk/*

ENV TERRAGRUNT_VERSION 0.38.4
RUN curl -f -Lo terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
  chmod +x terragrunt && \
  mv terragrunt /usr/bin

RUN addgroup -g 1000 jenkins && adduser -h /home/jenkins -G jenkins -u 1000 -D jenkins
USER jenkins
WORKDIR /home/jenkins
