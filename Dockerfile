FROM ubuntu:22.04

ARG ARM_GNU_VERSION=12.2.rel1
ARG ARM_GNU_DIR=/opt/arm-gnu

# Update repos
RUN  apt update -y

# Download and install ARM GNU Toolchain
RUN apt install -y wget tar xz-utils
RUN echo "Installing ARM GNU Toolcahin ${ARM_GNU_VERSION}"
RUN wget "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_GNU_VERSION}/binrel/arm-gnu-toolchain-${ARM_GNU_VERSION}-x86_64-arm-none-eabi.tar.xz"
RUN mkdir "$ARM_GNU_DIR"
RUN tar xf "arm-gnu-toolchain-${ARM_GNU_VERSION}-x86_64-arm-none-eabi.tar.xz" --strip-components=1 --directory "${ARM_GNU_DIR}"
ENV PATH="${PATH}:${ARM_GNU_DIR}/bin"
RUN arm-none-eabi-gcc --version

# Pyton required for GDB
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3.8 

# Install other tools
RUN apt install -y git stlink-tools openocd make cmake bsdextrautils libncursesw5


# Endless loop
# ENTRYPOINT ["tail", "-f", "/dev/null"]
